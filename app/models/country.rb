class Country < ApplicationRecord
    
    has_many :document_types, dependent: :destroy
    has_many :charge_points, dependent: :destroy
    has_one :setting
    
    accepts_nested_attributes_for :document_types, allow_destroy: true
    
    validates :name, :code, :money_code, :symbol, presence: true
    validates :name, :code, uniqueness: true
    validates :code, numericality: { only_integer: true }
    
    before_validation :format_attributes
    
    def format_attributes
        self.name = self.name.titleize if self.name.present?
    end
    
    def self.by_locale(locale)
        country = Country.find_by(locale: locale)
        return country.nil? ? Country.first : country
    end
    
    def unit
        "#{self.money_code}#{self.symbol}"
    end
    
end
