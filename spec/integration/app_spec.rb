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

  context 'GET /login' do
    it 'Creates a form for login' do
      response = get('/login')
      expect(response.status). to eq 200
      expect(response.body).to include 'Login'
    end
  end 
  
  context 'POST /login' do
    it 'Logs the user in' do
      response = post('/login', email: 'champ@weemail.com', password: 'heatbreakhotel')
      expect(response.status).to eq 302
    end
  end    
  
  context 'GET /booking' do 
    it 'return to the booking form' do 
      response = get('/booking/new')
      expect(response.status).to eq 302
    end 
  end 

  context 'POST /booking' do 
    it 'posts booking form to database' do 
      response = post('/booking', date: '2022-11-08', user_id: 1, listing_id: 1)
      expect(response.status).to eq 302
      repo = BookingRepository.new
      bookings = repo.all
      expect(bookings.last.date).to eq('2022-11-08')
      expect(bookings.last.user_id).to eq(1)
      expect(bookings.last.listing_id).to eq(1)
    end 
  end

  context 'GET /inbox' do 
    it 'displays inbox page with list of bookings' do 
      response = get('/inbox')
      expect(response.status).to eq 200
      expect(response.body).to include('')
      expect(response.body).to include('')
    end 
  end
  
  context 'GET /signup/new' do
    it 'redirects the user to the sign up page' do
      response = get('/signup/new')
      expect(response.status).to eq 200
    end
  end
  
  context 'POST /signup' do
    it 'creates a new user' do
      response = post('/signup', name: 'Tim', username: 'Timmy', email: 'tim@email', password: 'thing')
      repo = UserRepository.new
      users = repo.all
      expect(response.status).to eq 302
      expect(users.length).to eq 4
      expect(users.last.name).to eq 'Tim'
    end
  end    
  
  context 'GET /listing/new' do 
    it 'loads a form to create a new lisitng' do 
      response = get('/listing/new')
      expect(response.status).to eq 200 
    end 
  end

  context 'POST /listing/' do
    it 'creates a listing' do
      response = post('/listing', name: 'Property A', address: '12 Arroyo Lane', city: 'London', country: 'UK', ppn: '$120.00', description: 'nice place tbh', host_id: 2, available_start: '2022-11-20', available_end: '2022-12-31')
      repo = ListingRepository.new
      listings = repo.all
      expect(response.status).to eq 302
      expect(listings.length).to eq 7
    end
  end    
end
