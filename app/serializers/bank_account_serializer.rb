class BankAccountSerializer < ApplicationSerializer
  attributes :id, :bank, :number, :owner_name, :identification, :identification_front, :identification_back, :account_certificate
  has_one :document_type
  has_one :person
end
