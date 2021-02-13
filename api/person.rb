require 'Sequel'

class Persons < Grape::API
  version 'v1'
  format :json

  get '/person' do
    people = DB[:people]
    { people: people.map([:id, :name]) }
  end
end