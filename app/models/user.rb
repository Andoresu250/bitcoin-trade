class User < ApplicationRecord
    
    include AASM
    
    authenticates_with_sorcery!
    
    has_many :tokens
    
    belongs_to :profile, polymorphic: true, optional: true
    
    attr_accessor :password, :password_confirmation, :token
    
    scope :by_profile_type,     -> (type) { joins("LEFT JOIN people ON (users.profile_id = people.id AND users.profile_type = 'Person')").where("users.profile_type = :type OR people.profile_type = :type", {type: type}) }
    scope :by_email,            -> (email) { where("LOWER(users.email) LIKE ?", email.downcase ) }
    scope :by_state,            -> (state) { where("users.state LIKE ?", "%#{state}%")}
    
    scope :by_created_start_date, -> (date) { where("users.created_at >= ?", date) } 
    scope :by_created_end_date,   -> (date) { where("users.created_at <= ?", date) } 
    scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(users: {created_at: parse_date.midnight..parse_date.end_of_day})}
    
    validates :profile, presence: true, on: :deep_create
    validates :email, presence: true
    validates :password, :password_confirmation, presence: true, on: :create
    validates :email, uniqueness: { case_sensitive: true}, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/ }
    validates :password, length: {minimum: 8}, confirmation: true, on: :create
    
    before_validation :format_attributes
    
    aasm(:state) do
        state :activated, initial: true
        state :deactivated
    
        event  :activate do
            transitions  from: :deactivated, to: :activated
        end
        
        event  :deactivate do
            transitions  from: :activated, to: :deactivated
        end
    end
    
    def format_attributes
        if self.email
            self.email = self.email.gsub(/\s+/, "") 
            self.email = self.email.downcase
        end
    end
    
    def full_name
        self.profile.full_name
    end
    
    def role_to_number
        case self.profile_type
        when "Admin"
            return 5
        when "Investor"
            return 2
        when "Person"
            return 1
        else
            return nil
        end
    end
    
end
