json.extract! sale, :id, :person_id, :btc, :value, :country_id, :state, :wallet_url, :created_at, :updated_at
json.url sale_url(sale, format: :json)
