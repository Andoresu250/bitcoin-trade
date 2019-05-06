class PurchaseSerializer < ApplicationSerializer
  attributes :id, :btc, :value, :state, :wallet_url, :evidence, :bounty, :bounty_percentage
  has_one :person
  has_one :country
end
