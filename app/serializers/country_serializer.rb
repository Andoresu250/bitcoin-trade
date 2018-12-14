class CountrySerializer < ApplicationSerializer
  attributes :name, :code
  
  has_many :document_types, unless: :index?
  
end
