class ProfileSerializer < ApplicationSerializer
  attributes :full_name
  
  def full_name
      object.full_name
  end
end
