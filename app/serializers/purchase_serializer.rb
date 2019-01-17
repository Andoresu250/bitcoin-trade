class PurchaseSerializer < ApplicationSerializer
  attributes :id, :btc, :value, :state, :wallet_url, :evidence
  has_one :person
  has_one :country
end
