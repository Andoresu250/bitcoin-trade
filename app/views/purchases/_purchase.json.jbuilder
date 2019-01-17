json.extract! purchase, :id, :person_id, :btc, :value, :country_id, :state, :bank_account_id, :transfer_evidence, :deposit_evidence, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
