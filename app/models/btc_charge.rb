class BtcCharge < ApplicationRecord

    include AASM

    belongs_to :person

    mount_uploader :evidence, ImageUploader
    mount_uploader :qr, ImageUploader

    has_one :country, through: :person

    scope :by_state, -> (state) { where("btc_charges.state LIKE ?", "#{state}")}
    scope :aprobadas, -> {by_state("aprobado")}
    scope :denegadas, -> {by_state("denegado")}
    scope :by_created_start_date, -> (date) { where("btc_charges.created_at >= ?", date) }
    scope :by_created_end_date,   -> (date) { where("btc_charges.created_at <= ?", date) }
    scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(btc_charges: {created_at: parse_date.midnight..parse_date.end_of_day})}
    scope :by_month,              -> (date=DateTime.now.to_s) {by_created_date(date)}
    scope :by_person_name, -> (name) { joins(:person).where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ to_tsquery(?)", name.squeeze(" ").split(" ").join(" & ").downcase) }
    scope :by_name, -> (name) { joins(:person).where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ to_tsquery(?)", name.squeeze(" ").split(" ").join(" & ").downcase) }
    scope :by_identification, -> (identification) { joins(:person).where("people.identification LIKE ?", "%#{identification}%") }
    scope :by_phone, -> (phone) { joins(:person).where("people.phone LIKE ?", "%#{phone}%") }

    validates :btc, :state, presence: true
    validates :btc, numericality: { greater_than: 0 }

    validates :qr, presence: true, on: :approve
    validates :evidence, presence: true, on: :check

    def self.filters
        [
            :by_state,
            :by_person_name,
            :by_name,
            :by_identification,
            :by_phone
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
            transitions  from: [:pendiente, :aceptado, :validando], to: :denegado
        end

        event :check do
            transitions  from: :aceptado, to: :validando
        end

        event :successful do
            transitions  from: :validando, to: :exitoso
        end
    end

end
