class CountrySerializer < ApplicationSerializer
  attributes :name, :code, :locale, :time_zone, :money_code, :symbol
  
  has_many :document_types, unless: :index?
  
end
