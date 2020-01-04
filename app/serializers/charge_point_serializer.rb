class ChargePointSerializer < ApplicationSerializer
  attributes :owner, :account_type, :number, :owner_identification, :iban, :bank
  has_one :country
end
