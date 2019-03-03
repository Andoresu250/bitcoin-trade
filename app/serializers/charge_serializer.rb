class ChargeSerializer < ApplicationSerializer
  attributes :amount, :state, :evidence
  has_one :person
  has_one :country
end
