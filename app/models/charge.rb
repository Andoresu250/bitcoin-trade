class Charge < ApplicationRecord
    
    include AASM
    
    mount_uploader :evidence, ImageUploader
    
    belongs_to :person
    belongs_to :charge_point
    has_one :country, through: :person
    
    scope :by_state, -> (state) { where("charges.state LIKE ?", "#{state}")}
    scope :aprobadas, -> {by_state("aprobado")}
    scope :denegadas, -> {by_state("denegado")}
    scope :by_created_start_date, -> (date) { where("charges.created_at >= ?", date) } 
    scope :by_created_end_date,   -> (date) { where("charges.created_at <= ?", date) } 
    scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(charges: {created_at: parse_date.midnight..parse_date.end_of_day})}
    scope :by_month,              -> (date=DateTime.now.to_s) {by_created_date(date)}
    
    # validates :amount, :state, :evidence, presence: true
    validates :amount, :state, presence: true
    validates :amount, numericality: { greater_than: 0 }
    
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
