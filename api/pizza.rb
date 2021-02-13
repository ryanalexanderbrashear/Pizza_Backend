require 'Sequel'

class Pizzas < Grape::API
  version 'v1'
  format :json

  pizzas = DB[:pizzas]

  # Endpoint to retrieve all pizzas
  get '/pizza' do
    pizzas.all
  end

  # Endpoint to retrieve pizzas based on meat type
  # Params: meat_type
  params do
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  get '/pizzasByMeat' do
    pizzas.where(meat_type: params[:meat_type]).all
  end

  # Endpoint to create a new pizza
  # Params: name, meat_type
  params do
    requires :name, type: String, desc: "Name of the pizza"
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  post '/pizza' do
    pizzas.insert(:name => params[:name], :meat_type => params[:meat_type])
  end

  # Endpoint to update a pizza
  # Params: id, name, meat_type
  params do
    requires :id, type: Integer, desc: 'ID of the pizza to update'
    requires :name, type: String, desc: "Name of the pizza"
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  put '/pizza' do
    pizzas.where(id: params[:id]).update(:name => params[:name], :meat_type => params[:meat_type])
  end

  # Endpoint to delete a pizza
  # Params: id
  params do
    requires :id, type: Integer, desc: 'ID of the pizza to delete'
  end
  delete '/pizza' do
    pizzas.where(id: params[:id]).delete
  end
end