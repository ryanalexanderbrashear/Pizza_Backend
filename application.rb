# application.rb
require 'grape'

# Load files from the models and api folders
Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }

module API
  class Root < Grape::API
    format :json
    prefix :api

    # Simple endpoint to get the current status of our API.
    get :status do
      { status: 'ok' }
    end
  end
end

# Mounting the Grape application
Application = Rack::Builder.new do
  map "/" do
    run API::Root
  end
end