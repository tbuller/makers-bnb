require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/listing_repo'
require_relative './lib/database_connection'
require_relative './lib/user_repo'
require_relative './lib/bookings_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    repo = ListingRepository.new

    @listings = repo.all

    return erb(:index)
  end
  
  get '/listing/new' do 
   return erb(:new_listing)
  end 

  post '/listing' do
    listing = Listing.new

    listing.name = params[:name]
    listing.address = params[:address]
    listing.city = params[:city]
    listing.country = params[:country]
    listing.ppn = params[:ppn]
    listing.description = params[:description]
    listing.host_id = params[:host_id].to_i
    listing.available_start = params[:available_start]
    listing.available_end = params[:available_end]

    repo = ListingRepository.new
    repo.create(listing)

    redirect '/'
  end

  get '/listing/:id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:id])
    session[:listing_id] = @listing.id
    return erb(:listing)
  end

  get '/login' do
    return erb(:login)
  end 
  
  post '/login' do
    repo = UserRepository.new

    outcome = repo.all

    user = repo.find_by_email(params[:email])

    if outcome.to_s.include?(user.email)
      user_password = user.password
      if repo.valid_password?(user_password, params[:password]) == "success"
        session[:user_id] = user.id
        redirect '/'
      else  
        redirect '/login'
      end    
    else 
      redirect '/login'
    end
  end  

  get '/booking/new' do 
    return erb(:new_booking)
  end 

  post '/booking' do 
    booking = Booking.new
    
    booking.date = params[:date]
    booking.user_id = session[:user_id] ||= params[:user_id]
    booking.listing_id = session[:listing_id] ||= params[:listing_id]

    repo = BookingRepository.new 
    repo.create(booking)
  end 

  get '/signup/new' do
    return erb(:signup)
  end
  
  post '/signup' do
    user = User.new

    user.name = params[:name]
    user.username = params[:username]
    user.email = params[:email]
    user.password = params[:password]

    repo = UserRepository.new
    repo.create(user)

    redirect '/login'
  end  

  
end
