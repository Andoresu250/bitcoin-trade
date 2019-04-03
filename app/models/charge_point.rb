class ChargePoint < ApplicationRecord
    
    belongs_to :country
    
    validates :owner, :account_type, :number, :owner_identification, :bank, presence: true, on: :create
    validates :iban, presence: true, if: -> { country.present? && country.code == '34' }
    
    scope :by_country_id, -> (country_id) { where(country_id: Country.decode_id(country_id)) }
    
    def self.filters
        [:by_country_id]
    end
  
    
end
