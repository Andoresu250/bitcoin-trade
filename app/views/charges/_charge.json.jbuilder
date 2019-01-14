json.extract! charge, :id, :person_id, :amount, :state, :evidence, :created_at, :updated_at
json.url charge_url(charge, format: :json)
