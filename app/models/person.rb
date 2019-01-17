class Person < ApplicationRecord
  
  has_one :user, as: :profile, dependent: :destroy
  
  belongs_to :document_type
  belongs_to :country
  has_many :bank_accounts, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :sales
  has_many :purchases
  
  mount_uploader :identification_front, ImageUploader
  mount_uploader :identification_back, ImageUploader
  mount_uploader :public_receipt, ImageUploader
  
  # validates :first_names, :last_names, :identification, :phone, :identification_front, :identification_back, presence: true
  validates :first_names, :last_names, :identification, :phone, presence: true
  validates :identification, uniqueness: { scope: :document_type_id }
  validates_numericality_of :balance, greater_than_or_equal_to: 0
  
  def full_name
    "#{self.first_names} #{self.last_names}"
  end
end

