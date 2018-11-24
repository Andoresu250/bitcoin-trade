require 'active_support/concern'

module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def super_paginate(params = {})
      per_page = ApplicationRecord.validate_value(params[:per_page], ApplicationRecord.DEFAULT_PER_PAGE)
      page     = ApplicationRecord.validate_value(params[:page], ApplicationRecord.DEFAULT_PAGE)
      order_by = ApplicationRecord.validate_value(params[:order_by], ApplicationRecord.DEFAULT_ORDER_BY)
      dir      = ApplicationRecord.validate_value(params[:sort], ApplicationRecord.DEFAULT_DIR)
      
      order_by = "#{table_name}.#{order_by}" unless order_by.include?('.')
      
      return order("#{order_by} #{dir}").paginate(page: page, per_page: per_page)
    end
    
    def filter(params = {}, filters = self.filters, filter_cases = self.filter_cases)
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
      return results.super_paginate(params)
    end
    
  end
end