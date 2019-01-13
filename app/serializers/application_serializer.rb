class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
  
  def id
      object.hashid
  end
  
  def index?
    return scope == "index"
  end
  
end
