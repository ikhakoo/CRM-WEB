require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'

$rolodex= Rolodex.new

get '/' do
  @crm_app_name = "Imran\'s CRM"
  erb :index
end

get '/contacts' do
  erb :contacts
end
