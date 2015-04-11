require_relative 'rolodex'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

$rolodex= Rolodex.new
current_time = Time.new

class Contact
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String
end

DataMapper.finalize
DataMapper.auto_upgrade!
#index
get '/' do
  erb :index
end
#contacts display all
get "/contacts" do
  @contacts = Contact.all
  puts @contacts.inspect
  erb :contacts
end
## new contacts
get '/contacts/new' do
  erb :new_contact
end

post "/contacts/new" do
  puts "i've posted these from the form: #{params.inspect}"
  contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
  )
  redirect to('/contacts')
end
#show contact
get "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
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
#edit contact
get "/contacts/:id/edit" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

post "/contacts/:id/edit" do
  puts "i've posted these from the form: #{params.inspect}"
  @contact = Contact.get(params[:id].to_i)
    contact = Contact.update(
      @contact.first_name = params[:first_name],
      @contact.last_name = params[:last_name],
      @contact.email = params[:email],
      @contact.note = params[:note]
      )
    contact.save
end

#delete contact
delete '/contacts/:id' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.destroy
    redirect to '/contacts'
  else
    raise Sinatra:NotFound
  end
end

