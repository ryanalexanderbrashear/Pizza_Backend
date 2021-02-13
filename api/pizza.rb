require 'Sequel'

class Pizzas < Grape::API
  version 'v1'
  format :json

  pizzas = DB[:pizzas]

  get '/pizza' do
    pizzas.all
  end

  params do
    requires :name, type: String, desc: "Name of the pizza"
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  post '/pizza' do
    pizzas.insert(:name => params[:name], :meat_type => params[:meat_type])
  end

  params do
    requires :id, type: Integer, desc: 'ID of the pizza to update'
    requires :name, type: String, desc: "Name of the pizza"
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  put '/pizza' do
    pizzas.where(id: params[:id]).update(:name => params[:name], :meat_type => params[:meat_type])
  end

  params do
    requires :id, type: Integer, desc: 'ID of the pizza to delete'
  end
  delete '/pizza' do
    pizzas.where(id: params[:id]).delete
  end
end