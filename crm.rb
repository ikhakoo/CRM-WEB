require_relative 'contact'
require 'sinatra'

get '/' do
  @crm_app_name = "Imran\'s CRM"
  erb :index
end

get '/contacts' do
	@crm_app_name = "Imran\'s CRM"
	erb :contacts
end

