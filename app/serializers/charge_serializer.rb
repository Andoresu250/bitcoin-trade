class ChargeSerializer < ApplicationSerializer
  attributes :id, :amount, :state, :evidence
  has_one :person
  has_one :country
end
