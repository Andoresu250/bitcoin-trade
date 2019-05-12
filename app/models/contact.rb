class Contact < ApplicationRecord
    
    scope :by_name, -> (name) { where("LOWER(contacts.name) LIKE ?", "%#{name.downcase}%" ) }
    scope :by_phone, -> (phone) { where("LOWER(contacts.phone) LIKE ?", "%#{phone.downcase}%" ) }
    
    def self.filters
        [
            :by_name,
            :by_phone
        ]
    end
    
    
end
