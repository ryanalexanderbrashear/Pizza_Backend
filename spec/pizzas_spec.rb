require 'spec_helper'

describe API::Root::People do
  include Rack::Test::Methods

  def app
    APP
  end

  context 'GET /api/v1/pizza' do
    it 'returns 200' do
      get '/api/v1/pizza'
      expect(last_response.status).to eq(200)
    end
  end
end