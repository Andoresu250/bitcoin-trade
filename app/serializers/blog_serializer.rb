class BlogSerializer < ApplicationSerializer
  attributes :title, :body, :image, :author, :created_at
  
  def author
    object.user.full_name if object.user
  end
end
