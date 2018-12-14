class ApplicationSerializer < ActiveModel::Serializer
  attributes :id
  
  def id
      object.hashid
  end
  
  def index?
    return scope == "index"
  end
  
end
