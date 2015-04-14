require 'sinatra'
require 'data_mapper'
require 'pry'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :phone_number, String
  property :street_address, String
  property :postal_code, String
  property :city, String
  property :state, String
  property :country, String
  property :email, String
  property :note, String
end

class Inventory
  include DataMapper::Resource

  property :item_id, Serial
  property :item_brand, String
  property :item_type, String
  property :item_color, String
  property :item_cost, Float
  property :item_quantity, Integer
  property :item_sales_price, Float
  property :item_sales_tax, Float
  property :item_note, String
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
    :phone_number => params[:phone_number],
    :email => params[:email],
    :street_address => params[:street_address],
    :postal_code => params[:postal_code],
    :city => params[:city],
    :state => params[:state],
    :country => params[:country],
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
    @contact.phone_number = params[:phone_number]
    @contact.email = params[:email] 
    @contact.note = params[:note]
    @contact.street_address = params[:street_address]
    @contact.postal_code = params[:postal_code]
    @contact.city = params[:city]
    @contact.state = params[:state]
    @contact.country = params[:country]

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

put "/contacts/:id/edit" do
  puts "i've posted these from the form: #{params.inspect}"
  @contact = Contact.get(params[:id].to_i)
  contact = @contact.update(
      :first_name => params[:first_name],
      :last_name => params[:last_name],
      :phone_number => params[:phone_number],
      :email => params[:email],
      :note => params[:note],
      :street_address => params[:street_address],
      :postal_code => params[:postal_code],
      :city => params[:city],
      :state => params[:state],
      :country => params[:country]
      )
      @contact.save

      redirect to("/contacts")
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

#### Inventory ####

get "/inventory" do
  @inventory = Inventory.all
  puts @inventory.inspect
  erb :inventory
end

get '/inventory/new' do
  erb :new_inventory  
end

post "/inventory/new" do
  puts "i've posted these from the form: #{params.inspect}"
  inventory = Inventory.create(
    :item_brand => params[:item_brand],
    :item_type => params[:item_type],
    :item_color => params[:item_color],
    :item_quantity => params[:item_quantity],
    :item_cost => params[:item_cost],
    :item_sales_price => params[:item_sales_price],
    :item_sales_tax => params[:item_sales_tax],
    :item_note => params[:item_note]
  )
  redirect to('/inventory')
end

get "/inventory/:item_id" do
  @inventory = Inventory.get(params[:item_id].to_i)
  if @inventory
    erb :show_inventory
  else
    raise Sinatra::NotFound
  end
end

put "/inventory/:item_id" do
  @inventory = Inventory.get(params[:item_id].to_i)
  if @inventory
    @inventory.item_brand = params[:item_brand]
    @inventory.item_type = params[:item_type]
    @inventory.item_color = params[:item_color]
    @inventory.item_quantity = params[:item_quantity]
    @inventory.item_cost = params[:item_cost]
    @inventory.item_sales_price = params[:item_sales_price]
    @inventory.item_sales_tax = params[:item_sales_tax]
    @inventory.item_note = params[:item_note]
    redirect to("/inventory")
  else
    raise Sinatra::NotFound
  end
end
#edit inventory
get "/inventory/:item_id/edit" do
  @inventory = Inventory.get(params[:item_id].to_i)
  if @inventory
    erb :edit_inventory
  else
    raise Sinatra::NotFound
  end
end

put "/inventory/:item_id/edit" do
  puts "i've posted these from the form: #{params.inspect}"
  @inventory = Inventory.get(params[:item_id].to_i)
  inventory = @inventory.update(
    :item_brand => params[:item_brand],
    :item_type => params[:item_type],
    :item_color => params[:item_color],
    :item_quantity => params[:item_quantity],
    :item_cost => params[:item_cost],
    :item_sales_price => params[:item_sales_price],
    :item_sales_tax => params[:item_sales_tax],
    :item_note => params[:item_note]
    )
  @inventory.save

  redirect to("/inventory")
end

#delete inventory
delete '/inventory/:item_id' do
  @inventory = Inventory.get(params[:item_id].to_i)
  if @inventory
    @inventory.destroy
    redirect to '/inventory'
  else
    raise Sinatra:NotFound
  end
end

#search
post "/contacts/search" do
  search = params[:search]

  case params[:kind]
  when "inventory"
   @inventory = Inventory.all(:item_brand.like => search) |
                Inventory.all(:item_type.like => search) |
                Inventory.all(:item_color.like => search) |
                Inventory.all(:item_quantity.like => search) |
                Inventory.all(:item_cost.like => search) 
    if @inventory
      erb :inventory
    else
      raise Sinatra::NotFound
    end
  when "contacts"
    @contacts = Contact.all(:first_name.like => search) |
                Contact.all(:last_name.like => search) |
                Contact.all(:phone_number.like => search) |
                Contact.all(:street_address.like => search) |
                Contact.all(:postal_code.like => search) |
                Contact.all(:city.like => search) |
                Contact.all(:state.like => search) |
                Contact.all(:country.like => search) 
    if @contacts
      erb :contacts
    else
      raise Sinatra::NotFound
    end
  end
end

#help
get '/help' do
  erb :help
end


