# config.ru
require 'sequel'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins 'http://localhost:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

DB = Sequel.connect('postgres://localhost/pizza')

# Create the people table if it does not exist
if DB.table_exists?(:people) === false then 
  DB.create_table :people do
    primary_key :id
    String :name
  end
end

# Create the pizzas table if it does not exist
if DB.table_exists?(:pizzas) === false then 
  DB.create_table :pizzas do
    primary_key :id
    String :name
    String :meat_type
  end
end

require File.expand_path('../api/api', __FILE__)

run Application