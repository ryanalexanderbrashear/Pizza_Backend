require 'sequel'

class Pizzas < Grape::API
  version 'v1'
  format :json

  pizzas = DB[:pizzas]

  # Endpoint to retrieve all pizzas
  get '/pizza' do
    pizzas.all
  end

  # Endpoint to create a new pizza
  # Params: meat_type
  params do
    requires :meat_type, type: String, desc: "Meat type of the pizza"
  end
  post '/pizza' do
    pizzas.insert(:meat_type => params[:meat_type])
  end

  # Endpoint to update a pizza
  # Params: id, meat_type
  params do
    requires :id, type: Integer, desc: 'ID of the pizza to update'
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  put '/pizza' do
    pizzas.where(id: params[:id]).update(:meat_type => params[:meat_type])
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