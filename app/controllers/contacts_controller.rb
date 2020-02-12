class ContactsController < ApplicationController
  # before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    contacts = Contact.super_filter(params)
    return renderCollection("contacts", contacts, ContactSerializer)
  end

  def create
    contacts_params = params[:contacts]
    contacts_params = contacts_params.map{|c| c.permit(:name, :phone)}
    Contact.create(contacts_params)
    return renderJson(:ok)
    # contacts_params.each do |contact_hash|

    #   puts contact_hash.permit(:name, :phone)
    # end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :phone)
    end
end
