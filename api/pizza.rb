require 'Sequel'

class Pizzas < Grape::API
  version 'v1'
  format :json

  get '/pizza' do
    pizzas = DB[:pizzas]
    { count: pizzas.count }
  end
end