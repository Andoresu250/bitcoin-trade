class CalculatorSerializer < ActiveModel::Serializer
  attributes :btc, :currency, :symbol, :value
end
