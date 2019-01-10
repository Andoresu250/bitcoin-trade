class BankAccount < ApplicationRecord
  belongs_to :document_type
  belongs_to :person
end
