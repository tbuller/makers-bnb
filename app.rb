require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/listing_repo'
require_relative './lib/database_connection'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    repo = ListingRepository.new

    @listings = repo.all

    return erb(:index)
  end
  
  get '/listing/:id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:id])
    return erb(:listing)
  end

  get '/booking/new' do 
    return erb(:new_booking)
  end 

  post '/booking' do 
    booking = Booking.new
    
    booking.date = params[:date]
    booking.user_id = params[:user_id]
    booking.listing_id = params[:listing_id]

    repo = BookingRepository.new 
    repo.create(booking)
  end 
  
end