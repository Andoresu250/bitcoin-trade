class Person < ApplicationRecord

  scope :by_name, -> (name) { where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ to_tsquery(?)", name.squeeze(" ").split(" ").join(" & ").downcase) }
  scope :by_identification, -> (identification) { where("people.identification LIKE ?", "%#{identification}%") }
  scope :by_phone, -> (phone) { where("people.phone LIKE ?", "%#{phone}%") }

  has_one :user, as: :profile, dependent: :destroy

  belongs_to :document_type
  belongs_to :country
  has_many :bank_accounts, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :btc_charges, dependent: :destroy
  has_many :sales
  has_many :purchases

  mount_uploader :identification_front, ImageUploader
  mount_uploader :identification_back, ImageUploader
  mount_uploader :public_receipt, ImageUploader

  validates :first_names, :last_names, :identification, :phone, :identification_front, :identification_back, presence: true, on: :create
  # validates :first_names, :last_names, :identification, :phone, presence: true
  validates :identification, uniqueness: { scope: :document_type_id }
  validates_numericality_of :balance, greater_than_or_equal_to: 0
  validates_numericality_of :btc, greater_than_or_equal_to: 0

  def self.filters
    [
      :by_name,
      :by_identification,
      :by_phone
    ]
  end

  def full_name
    "#{self.first_names} #{self.last_names}"
  end
end

