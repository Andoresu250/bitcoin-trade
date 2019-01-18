class Charge < ApplicationRecord
    
    include AASM
    
    mount_uploader :evidence, ImageUploader
    
    belongs_to :person
    has_one :country, through: :person
    
    scope :by_state, -> (state) { where("charges.state LIKE ?", "#{state}")}
    
    validates :amount, :state, :evidence, presence: true
    # validates :amount, :state, presence: true
    
    def self.filters
        [
            :by_state
        ]
    end
    
    aasm(:state) do
        state :pendiente, initial: true
        state :aprobado
        state :denegado
    
        event  :approve do
            transitions  from: :pendiente, to: :aprobado
        end
        
        event :deny do
            transitions  from: :pendiente, to: :denegado
        end
    end
    
end
