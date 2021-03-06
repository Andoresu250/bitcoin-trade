class Sale < ApplicationRecord

  include AASM

  belongs_to :person
  belongs_to :country
  belongs_to :bank_account
  has_one :user, through: :person

  mount_uploader :transfer_evidence, ImageUploader
  mount_uploader :deposit_evidence, ImageUploader

  scope :by_state, -> (state) { where("sales.state LIKE ?", "#{state}")}
  scope :aprobadas, -> {by_state("aprobado")}
  scope :by_created_start_date, -> (date) { where("sales.created_at >= ?", date) }
  scope :by_created_end_date,   -> (date) { where("sales.created_at <= ?", date) }
  scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(sales: {created_at: parse_date.midnight..parse_date.end_of_day})}
  scope :by_month,              -> (date=DateTime.now.to_s) {by_created_date(date)}
  scope :by_person_name, -> (name) { joins(:person).where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ to_tsquery(?)", name.squeeze(" ").split(" ").join(" & ").downcase) }
  scope :by_name, -> (name) { joins(:person).where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ to_tsquery(?)", name.squeeze(" ").split(" ").join(" & ").downcase) }
  scope :by_identification, -> (identification) { joins(:person).where("people.identification LIKE ?", "%#{identification}%") }
  scope :by_phone, -> (phone) { joins(:person).where("people.phone LIKE ?", "%#{phone}%") }

  # validates :btc, :value, :transfer_evidence, presence: true, on: :create
  validates :btc, :value, presence: true, on: :create

  validates :deposit_evidence, presence: true, on: :approve
  before_create :set_bounty

  def self.filters
    [
      :by_state,
      :by_person_name,
      :by_name,
      :by_identification,
      :by_phone
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

    event  :approve, after_commit: :after_approve do
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

  def after_approve
    if self.user.referred_user&.enable_referred
      referred_user = self.user.referred_user
      bonus = self.value * 0.0001
      referred_user.bonus += bonus
      referred_user.balance += bonus
      referred_user.save(validate: false)
    end
  end

end
