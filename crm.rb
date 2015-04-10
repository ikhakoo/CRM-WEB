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

get "/contacts/1000" do
  @contact = @@rolodex.find(1000)
  erb :show_contact
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