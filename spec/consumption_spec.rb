require 'spec_helper'
require 'json'

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

  context 'GET /api/v1/consumptionStreaks' do
    it 'returns 200' do
      get '/api/v1/consumptionStreaks'
      expect(last_response.status).to eq(200)
    end
    it 'returns an array of streaks' do
      get '/api/v1/consumptionStreaks'
      expect(JSON.parse(last_response.body)).to be_an_instance_of(Array)
    end
    it 'returns correct streaks based on CSV input' do
      expectedResponse = JSON.parse("[[\"2015-01-03\",\"2015-01-06\",\"2015-01-07\"],[\"2015-02-01\",\"2015-03-01\"],[\"2015-04-01\",\"2015-05-01\"]]")
      get '/api/v1/consumptionStreaks'
      expect(JSON.parse(last_response.body)).to eq(expectedResponse)
    end
  end

  context 'GET /api/v1/consumptionByMonth' do
    it 'returns 200' do
      get '/api/v1/consumptionByMonth'
      expect(last_response.status).to eq(200)
    end
    it 'returns an array of records' do
      get '/api/v1/consumptionByMonth'
      expect(JSON.parse(last_response.body)).to be_an_instance_of(Array)
    end
    it 'returns correct monthly records based on CSV input' do
      expectedResponse = [{"count"=>3, "date"=>"2015-01-07"},{"count"=>1, "date"=>"2015-02-01"},{"count"=>2, "date"=>"2015-03-01"},{"count"=>1, "date"=>"2015-04-01"},{"count"=>3, "date"=>"2015-05-01"},nil,nil,{"count"=>1, "date"=>"2015-08-01"},nil,nil,nil,nil]
      get '/api/v1/consumptionByMonth'
      expect(JSON.parse(last_response.body)).to eq(expectedResponse)
    end
  end
end