class Admin < ApplicationRecord
    
    has_one :user, as: :profile
    
    validates :name, presence: true
    
    def full_name
        self.name
    end
    
end
