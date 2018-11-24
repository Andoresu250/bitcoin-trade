class SessionSerializer < ApplicationSerializer
  attributes :email, :profile_type, :token, :profile
  
  def profile
    case object.profile_type
    when "Admin"
        ActiveModelSerializers::SerializableResource.new(object.profile, serializer: AdminSerializer)
    when "Person"
        ActiveModelSerializers::SerializableResource.new(object.profile, serializer: PersonSerializer)
    when "Investor"
        ActiveModelSerializers::SerializableResource.new(object.profile, serializer: InvestorSerializer)
    end
  end
end
