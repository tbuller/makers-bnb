require_relative '../../lib/listing_repo'
require_relative '../../lib/database_connection'
require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  
  include Rack::Test::Methods
  let(:app) { Application.new }

  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq 200
      expect(response.body).to include('Makersbnb')
      expect(response.body).to include('Beautiful 2-bed maisonette')
      expect(response.body).to include('Flashy mansion')
      expect(response.body).to include('Cute caravan x')
      expect(response.body).to include('London')
      expect(response.body).to include('Norway')
      expect(response.body).to include('$760.00')
    end
  end

  context 'GET /login' do
    it 'logs the user in' do
      response = get('/login')
      
      expect(response.status). to eq 200
      expect(response.body).to include 'Login'
      
      
    end
  end 
  
  context 'POST /login' do
    it 'Creates a form for login' do

      response = post('/login', email: 'champ@weemail.com', password: 'heatbreakhotel')
      expect(response.status).to eq 302
    end
  end    
end
