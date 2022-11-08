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
  
  context 'GET listing/:id' do
  it 'returns listing ID 2 page' do
    response = get('/listing/2')      
    expect(response.status).to eq 200
    expect(response.body).to include('Pokey underground bedsit')
    expect(response.body).to include('72 Wally Street')
    expect(response.body).to include('United States')
  end
end

  context 'GET /booking' do 
    it 'return to the booking form' do 
      response = get('/booking/new')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Create Booking</h1>')
      expect(response.body).to include('<input type="date" name="date">')
      expect(response.body).to include('<input type="submit" value="Book">')
    end 
  end 

end
