class DocumentType < ApplicationRecord

  belongs_to :country, inverse_of: :document_types

  scope :by_country_id, -> (country_id) { where(country_id: Country.decode_id(country_id)) }

  validates_presence_of :country

  validates :name, :abbreviation, presence: :true
  validates :name, :abbreviation, presence: :true, uniqueness: { scope: :country_id }

  before_validation :format_attributes

  def format_attributes
    self.name = self.name.titleize if self.name.present?
    self.abbreviation = self.abbreviation.upcase if self.abbreviation.present?
  end

  def self.filters
    []
  end

end
