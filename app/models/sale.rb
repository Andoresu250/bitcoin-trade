class Sale < ApplicationRecord
  
  include AASM
  
  belongs_to :person
  belongs_to :country
  belongs_to :bank_account
  
  mount_uploader :transfer_evidence, ImageUploader
  mount_uploader :deposit_evidence, ImageUploader
  
  scope :by_state, -> (state) { where("sales.state LIKE ?", "#{state}")}
  scope :aprobadas, -> {by_state("aprobado")}
  scope :by_created_start_date, -> (date) { where("sales.created_at >= ?", date) } 
  scope :by_created_end_date,   -> (date) { where("sales.created_at <= ?", date) } 
  scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(sales: {created_at: parse_date.midnight..parse_date.end_of_day})}
  scope :by_month,              -> (date=DateTime.now.to_s) {by_created_date(date)}
  
  # validates :btc, :value, :transfer_evidence, presence: true, on: :create
  validates :btc, :value, presence: true, on: :create
  
  validates :deposit_evidence, presence: true, on: :approve
  before_create :set_bounty
  
  def self.filters
    [
      :by_state
    ]
  end
  
  def set_bounty
    if self.country && self.value
      setting = self.country.setting
      self.bounty_percentage = setting.sale_percentage
      self.bounty = self.value * (1.0 - (1.0/(1 + self.bounty_percentage)))
    end
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