require 'Sequel'

class Persons < Grape::API
  version 'v1'
  format :json

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
    people.where(:name => params[:name]).first.to_json
  end
end