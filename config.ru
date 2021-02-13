# config.ru
require 'sequel'
require 'rack/cors'
require 'csv'

# CORS configuration to allow frontend
use Rack::Cors do
  allow do
    origins 'http://localhost:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

# Connect to postgres database 'pizza' on localhost
DB = Sequel.connect('postgres://localhost/pizza')

# Create the people table if it does not exist
if DB.table_exists?(:people) === false then 
  DB.create_table :people do
    primary_key :id
    String :name
  end
else 
  # If the table already exists, clear it out upon server start (for testing purposes)
  DB[:people].delete
end

# Create the pizzas table if it does not exist
if DB.table_exists?(:pizzas) === false then 
  DB.create_table :pizzas do
    primary_key :id
    String :name
    String :meat_type
  end
else 
  # If the table already exists, clear it out upon server start (for testing purposes)
  DB[:pizzas].delete
end

# Create the consumption table if it does not exist
if DB.table_exists?(:consumption) === false then 
  DB.create_table :consumption do
    primary_key :id
    foreign_key :person_id, :people
    foreign_key :pizza_id, :pizzas
    Date :date
  end
else 
  # If the table already exists, clear it out upon server start (for testing purposes)
  DB[:consumption].delete
end

csv_data = CSV.read("data.csv")

require File.expand_path('../api/api', __FILE__)

run Application