json.extract! bank_account, :id, :bank, :number, :identification, :document_type_id, :identification_front, :identification_back, :account_certificate, :person_id, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
