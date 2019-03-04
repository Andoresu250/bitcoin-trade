class Sale < ApplicationRecord
  
  include AASM
  
  belongs_to :person
  belongs_to :country
  belongs_to :bank_account
  
  mount_uploader :transfer_evidence, ImageUploader
  mount_uploader :deposit_evidence, ImageUploader
  
  scope :by_state, -> (state) { where("sales.state LIKE ?", "#{state}")}
  
  # validates :btc, :value, :transfer_evidence, presence: true, on: :create
  validates :btc, :value, presence: true, on: :create
  
  validates :deposit_evidence, presence: true, on: :approve
  
  def self.filters
    [
      :by_state
    ]
  end
  
  aasm(:state) do
    state :pendiente, initial: true
    state :aprobado
    state :denegado

    event  :approve do
      transitions  from: :pendiente, to: :aprobado
    end
    
    event :deny do
      transitions  from: :pendiente, to: :denegado
    end
  end
  
  def set_value
    attributes = {
      btc: self.btc,
      mode: Calculator.SELL_MODE
    }
    if self.country.present?
      attributes[:currency] = self.country.money_code
      attributes[:symbol] = self.country.symbol
    end
    calculator = Calculator.new(attributes)
    self.value = calculator.value
  end
  
end