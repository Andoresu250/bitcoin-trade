class Person < ApplicationRecord
  belongs_to :document_type
  belongs_to :country
  has_many :bank_accounts
  
  mount_uploader :identification_front, ImageUploader
  mount_uploader :identification_back, ImageUploader
  mount_uploader :public_receipt, ImageUploader
  
  validates :first_names, :last_names, :identification, :phone, :identification_front, :identification_back, presence: true
end
