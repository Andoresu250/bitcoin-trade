class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  include Filterable
  include Hashid::Rails
  include ActiveRecord::AttributeAssignmentOverride
  
  def self.filters
    []
  end
  
  def self.filter_cases
      []
  end

  def self.exclude_filters_for_search
    []
  end

  def self.validate_value(value, default)
      return false if value == "false"
      return default if value == 'undefined'
      return default if value.blank?
      return value
  end

  def self.DEFAULT_PER_PAGE
      10
  end

  def self.DEFAULT_PAGE
      1
  end

  def self.DEFAULT_ORDER_BY
      'created_at'
  end

  def self.DEFAULT_DIR
      'DESC'
  end
end
