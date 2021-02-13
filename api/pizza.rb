require 'Sequel'

class Pizzas < Grape::API
  version 'v1'
  format :json

  pizzas = DB[:pizzas]

  get '/pizza' do
    { pizzas: pizzas.map([:id, :name, :meat_type]) }
  end

  params do
    requires :name, type: String, desc: "Name of the pizza"
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  post '/pizza' do
    pizzas.insert(:name => params[:name], :meat_type => params[:meat_type])
  end
end