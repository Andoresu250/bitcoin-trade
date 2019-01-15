class Blog < ApplicationRecord
    
    mount_uploader :image, BlogImageUploader
    
    belongs_to :user
  
    # validates :title, :body, :image, presence: true
    validates :title, :body, presence: true
    
    scope :by_title, -> (title) { where("LOWER(blogs.title) LIKE ?", "%#{title.downcase}%") }
    scope :by_created_start_date, -> (date) { where("blogs.created_at >= ?", date) } 
    scope :by_created_end_date,   -> (date) { where("blogs.created_at <= ?", date) } 
    scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date); where(blogs: {created_at: parse_date.midnight..parse_date.end_of_day})}
    
    def self.filters
        [:by_title, :by_created_start_date, :by_created_end_date, :by_created_date]
    end
    
    def self.filter_cases
        cases = []
        cases << {
            key: :by_created_date,
            ignored: [:by_created_start_date, :by_created_end_date]
        }
        return cases
    end
    
end
