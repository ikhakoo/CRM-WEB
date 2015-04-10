require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'

@@rolodex = Rolodex.new
@@rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))
$rolodex= Rolodex.new
current_time = Time.new
contact = @@rolodex.find(1000)

get '/' do
  @crm_app_name = "Imran\'s CRM"
  @crm_current_time = current_time.getlocal
  erb :index
end

get '/contacts' do
	@crm_app_name = "Imran\'s CRM"
  @crm_current_time = current_time.getlocal
  erb :contacts
end

get '/contacts/new' do
  @crm_app_name = "Imran\'s CRM"
  @crm_current_time = current_time.getlocal
  erb :new_contact
end

get '/contacts/delete' do
  @crm_app_name = "Imran\'s CRM"
  @crm_current_time = current_time.getlocal
  erb :delete
end

post '/contacts' do
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end

get "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

