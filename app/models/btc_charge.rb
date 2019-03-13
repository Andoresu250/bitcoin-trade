class BtcCharge < ApplicationRecord
    
    include AASM
    
    belongs_to :person
  
    mount_uploader :evidence, ImageUploader
    mount_uploader :qr, ImageUploader
  
    has_one :country, through: :person
    
    scope :by_state, -> (state) { where("btc_charges.state LIKE ?", "#{state}")}
    
    validates :btc, :state, presence: true
    
    validates :qr, presence: true, on: :approve
    validates :evidence, presence: true, on: :check
    
    def self.filters
        [
            :by_state
        ]
    end
    
    aasm(:state) do
        state :pendiente, initial: true
        state :aceptado
        state :exitoso
        state :denegado
        state :validando
    
        event  :approve do
            transitions  from: :pendiente, to: :aceptado
        end
        
        event :deny do
            transitions  from: [:pendiente, :aceptado], to: :denegado
        end
        
        event :check do
            transitions  from: :aceptado, to: :validando
        end
        
        event :successful do
            transitions  from: :validando, to: :exitoso
        end
    end
  
end
