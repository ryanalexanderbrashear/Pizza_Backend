require 'Sequel'

class Persons < Grape::API
  version 'v1'
  format :json

  people = DB[:people]

  get '/people' do
    people.map([:id, :name])
  end

  params do
    requires :name, type: String, desc: "Name of the person"
  end
  get '/person' do
    people.where(:name => params[:name]).first.to_json
  end
end