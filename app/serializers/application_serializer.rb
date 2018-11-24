class ApplicationSerializer < ActiveModel::Serializer
  attributes :id
  
  def id
      object.hashid
  end
end
