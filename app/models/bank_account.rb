class BankAccount < ApplicationRecord
  belongs_to :document_type
  belongs_to :person
  
  mount_uploader :identification_front, ImageUploader
  mount_uploader :identification_back, ImageUploader
  mount_uploader :account_certificate, ImageUploader
  
  validates :bank, :number, :identification, :identification_front, :identification_back, :owner_name, presence: true
end
