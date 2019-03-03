class BtcChargeSerializer < ApplicationSerializer
  attributes :btc, :state, :evidence, :qr
  has_one :person
  has_one :country
end
