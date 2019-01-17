class Purchase < ApplicationRecord
  belongs_to :person
  belongs_to :country
  belongs_to :bank_account
end
