require 'active_support/concern'

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def or_scopes(*scopes)
      selects = []
      orders = []
      wheres = scopes.map do |scope|
        selects << scope.projections
        orders << scope.orders
        if scope.arel.where_sql.present?
          scope.arel.where_sql.gsub(/\AWHERE /i, "")
        else
          nil
        end
      end
      scope = where(wheres.compact.join(" OR "))
      selects.flatten.each { |s| scope = scope.select(s) }
      orders.flatten.each { |o| scope = scope.order(o) }
      scope
    end
  end

  class_methods do
    
    def super_paginate(params = {})
      per_page = ApplicationRecord.validate_value(params[:per_page], ApplicationRecord.DEFAULT_PER_PAGE)
      page     = ApplicationRecord.validate_value(params[:page], ApplicationRecord.DEFAULT_PAGE)
      order_by = ApplicationRecord.validate_value(params[:order_by], ApplicationRecord.DEFAULT_ORDER_BY)
      dir      = ApplicationRecord.validate_value(params[:sort], ApplicationRecord.DEFAULT_DIR)
      
      order_by = "#{table_name}.#{order_by}" unless order_by.include?('.')
      
      return order("#{order_by} #{dir}").paginate(page: page, per_page: per_page)
    end
    
    def chain_or(filters = self.filters, search)
      filters = filters.map { |f| f.to_s}
      if filters.empty?
        return self.all
      end
      fun = "self.#{filters.first}(search)"
      if filters.size > 1
        (1..filters.size - 1).each do |i|
          fun += ".or(self.#{filters[i]}(search))"
        end
      end
      return eval(fun)
    end
    
    def filter(params = {}, filters = self.filters, filter_cases = self.filter_cases, exclude_filters_for_search = self.exclude_filters_for_search)
      

      search = params[:search]
      if !search.nil? && !search.empty?
        filters = filters.delete_if { |f| exclude_filters_for_search.include?(f) }
        # results = or_scopes(*filters.map { |f| self.public_send(f, search)})
        results = chain_or(filters, search)
      else
        filter_cases.each do |filter_case|
          if params[filter_case[:key]].present?
            filter_case[:ignored].each {|ignored| filters.delete(ignored) }
          end
        end
        filtering_params = params.slice(*filters)
        results = self.where(nil)
        filtering_params.each do |key, value|
          results = results.public_send(key, value) if value.present?
        end       
      end

       
      return results.super_paginate(params)
    end
    
  end
end