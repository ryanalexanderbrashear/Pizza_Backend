require 'spec_helper'

describe API::Root::Consumption do
  include Rack::Test::Methods

  def app
    APP
  end
  
  context 'GET /api/v1/consumption' do
    it 'returns 200' do
      get '/api/v1/consumption'
      expect(last_response.status).to eq(200)
    end
  end
end