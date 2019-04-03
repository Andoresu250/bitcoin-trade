json.extract! charge_point, :id, :owner, :account_type, :number, :owner_identification, :iban, :created_at, :updated_at
json.url charge_point_url(charge_point, format: :json)
