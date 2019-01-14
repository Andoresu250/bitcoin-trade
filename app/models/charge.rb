class Charge < ApplicationRecord
    
    include AASM
    
    mount_uploader :evidence, ImageUploader
    
    belongs_to :person
    has_one :country, through: :person
    
    # validates :amount, :state, :evidence, presence: true
    validates :amount, :state, presence: true
    
    aasm(:state) do
        state :pendiente, initial: true
        state :aprovado
        state :denegado
    
        event  :approve do
            transitions  from: :pendiente, to: :aprovado
        end
        
        event :deny do
            transitions  from: :pendiente, to: :denegado
        end
    end
end
