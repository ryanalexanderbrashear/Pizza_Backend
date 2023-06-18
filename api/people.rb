require 'sequel'

class People < Grape::API
  version 'v1'
  format :json

  # Use sequel to connect to the needed databases
  people = DB[:people]

  # Endpoint to get all people
  get '/people' do
    people.all
  end

  # Endpoint to get a specific person
  # params: name
  params do
    requires :name, type: String, desc: "Name of the person"
  end
  get '/person' do
    people.where(:name => params[:name]).first
  end
end