class DocumentTypeSerializer < ApplicationSerializer
  attributes :id, :name, :abbreviation
  has_one :country
  
end
