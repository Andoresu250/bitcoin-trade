class MyUserSerializer < ApplicationSerializer
  attributes :email, :profile_type, :profile, :state, :enable_referred, :referred_person

  def referred_person
    object.referred_user&.profile
  end

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
