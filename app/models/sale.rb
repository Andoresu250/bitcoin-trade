class Sale < ApplicationRecord
  
  include AASM
  
  belongs_to :person
  belongs_to :country
  
  mount_uploader :evidence, ImageUploader
  
  validates :value, :btc, :wallet_url, presence: true
  
  aasm(:state) do
    state :pendiente, initial: true
    state :aprovado
    state :denegado

    event  :approve do
      transitions  from: :pendiente, to: :aprovado
    end
    
    event :deny do
      transitions  from: :pendiente, to: :denegado
    end
  end
  
  def set_btc
    attributes = {
      value: self.value
    }
    if self.country.present?
      attributes[:currency] = self.country.money_code
      attributes[:symbol] = self.country.symbol
    end
    calculator = Calculator.new(attributes)
    self.btc = calculator.btc
  end
  
end
