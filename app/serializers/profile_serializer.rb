class ProfileSerializer < ApplicationSerializer
  attributes :full_name, :type
  
  def full_name
      object.full_name
  end
    
  def type
      object.class.name
  end
end
