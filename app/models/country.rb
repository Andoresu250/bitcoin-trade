class Country < ApplicationRecord
    
    has_many :document_types
    
    accepts_nested_attributes_for :document_types, allow_destroy: true
    
    validates :name, :code, presence: true, uniqueness: true
    validates :code, numericality: { only_integer: true }
    
    before_validation :format_attributes
    
    def format_attributes
        self.name = self.name.titleize if self.name.present?
    end
    
end
