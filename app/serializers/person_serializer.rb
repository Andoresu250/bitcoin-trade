class PersonSerializer < ProfileSerializer
  attributes :first_names, :last_names, :identification, :phone, :identification_front, :identification_back, :public_receipt, :balance
  has_one :document_type
  has_one :country
end
