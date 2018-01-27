class ContactsController < ApplicationController
  def one_contact_method
    contact = Contact.first
    render json:contact.as_json  
  end
  def all_contacts_method
    contacts = Contact.all
    render json:contacts.as_json
  end 
  def index
    @contacts = Contact.all 
    search_first_name = params[:search_first_name]
    sort_attribute = params[:sort_last_name]
    if search_first_name
      @contacts = @contacts.where("first_name iLike ?","%#{search_first_name}%")
    end
    if sort_attribute
      @contacts = @contacts.order(sort_attribute => :asc)
    end
    render 'index.json.jbuilder'
  end
  def create
    @contact = Contact.new(
        first_name: params[:first_name],
        middle_name:params[:middle_name],
        last_name: params[:last_name],
        email: params[:email],
        phone_number: params[:phone_number],
        bio: params[:bio]
      )
    @contact.save
    if @contact.save
      render 'show.json.jbuilder'
    else
      render json:{errors:@contact.errors.full_messages}, status: 422
    end
  end
  def show
    @contact = Contact.find(params[:id])
    render 'show.json.jbuilder'
  end
  def update
    @contact = Contact.find(params[:id])
    @contact.first_name = params[:first_name] || @contact.first_name
    @contact.middle_name = params[:middle_name] || @contact.middle_name
    @contact.last_name = params[:last_name] || @contact.last_name
    @contact.email = params[:email] || @contact.email
    @contact.phone_number = params[:phone_number] || @contact.phone_number
    @contact.bio = params[:bio] || @contact.bio
    @contact.save
    if @contact.save
      render 'update.json.jbuilder'
    else
      render json:{errors:@contact.errors.full_messages}, status: :unprocessable_entity
    end
  end 
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy 
    render json:{message:"Successfully destroyed Contact id:#{@contact.id}"}
  end 
end
