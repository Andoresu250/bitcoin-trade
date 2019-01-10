class CountrySerializer < ApplicationSerializer
  attributes :name, :code, :locale, :time_zone
  
  has_many :document_types, unless: :index?
  
end
