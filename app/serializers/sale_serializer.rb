class SaleSerializer < ApplicationSerializer
  attributes :btc, :value, :state, :transfer_evidence, :deposit_evidence, :bounty, :bounty_percentage
  has_one :person
  has_one :country
  has_one :bank_account
end
