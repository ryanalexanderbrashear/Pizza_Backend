require 'spec_helper'

describe API::Root do
  include Rack::Test::Methods

  def app
    APP
  end

  context 'GET /api/status' do
    it 'returns 200' do
      get '/api/status'
      expect(last_response.status).to eq(200)
    end
    it 'returns ok' do
      get '/api/status'
      expect(last_response.body).to eq({ status: 'ok' }.to_json)
    end
  end
end
