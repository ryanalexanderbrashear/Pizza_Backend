# config.ru
require 'sequel'
require 'rack/cors'
require 'csv'

# CORS configuration to allow frontend to connect without CORS errors
use Rack::Cors do
  allow do
    origins 'http://localhost:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

# Connect to postgres database hosted on Heroku
DB = Sequel.connect('postgres://bgkpskvnikound:4ad34782cbd59974a98e602deb657bfaf30309b70e98c5f1af1fc53d1a31c3f4@ec2-34-203-155-237.compute-1.amazonaws.com:5432/d9vbv55mt1k6s2', adapter: 'postgres')

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
    foreign_key :person_id, :people, on_delete: :cascade
    foreign_key :pizza_id, :pizzas, on_delete: :cascade
    Date :date
  end
else 
  # If the table already exists, clear it out upon server start (for testing purposes)
  DB[:consumption].delete
end

# Parse the CSV file
csv_data = CSV.parse(File.read("data.csv"), headers: true)

# Obtain the unique people name entries from the CSV data
people = csv_data.by_col[0].uniq

# Insert the unique name entries into the people table
people.map { |name| DB[:people].insert(:name => name) }

# Obtain the unique pizza meat type entries from the CSV data
pizzas = csv_data.by_col[1].uniq

# Insert the unique name entries into the pizzas table
pizzas.map { |meat_type| DB[:pizzas].insert(:meat_type => meat_type) }

# Map through the CSV data to get the person, pizza, and date
csv_data.map { |data|
  person = data[0]
  pizza = data[1]
  date = data[2]

  # Get the corresponding IDs from the people and pizzas tables to insert into this record
  person_id = DB[:people].where(:name => person).first[:id]
  pizza_id = DB[:pizzas].where(:meat_type => pizza).first[:id]

  # Insert the record into the consumption table
  DB[:consumption].insert(:person_id => person_id, :pizza_id => pizza_id, :date => date)
}

# Get the absolute path of the main API file (api.rb) and require it
require File.expand_path('../api/api', __FILE__)

# Run the application in api.rb
run Application