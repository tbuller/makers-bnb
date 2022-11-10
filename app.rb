require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require_relative './lib/listing_repo'
require_relative './lib/database_connection'
require_relative './lib/user_repo'
require_relative './lib/bookings_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
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

    if repo.invalid_login_parameters?(params[:email], params[:password])
      flash[:notice] = "Please do not leave any fields blank. HTML is not permitted."
      redirect '/login'
    end

    user = repo.find_by_email(params[:email])

    if user != nil
      if repo.valid_password?(user.password, params[:password]) == "success"
        session[:user_id] = user.id
        redirect '/'
      else
        redirect '/login'
      end    
    else 
      redirect '/login' # you havent signed up link here?
    end
  end  

  get '/booking/new' do
    if session[:user_id] == nil
      redirect '/login'
    else
      return erb(:new_booking)
    end
  end 

  post '/booking' do 
    booking = Booking.new
  
    booking.date = params[:date]
    booking.user_id = session[:user_id] ||= params[:user_id]
    booking.listing_id = session[:listing_id] ||= params[:listing_id]

    repo = BookingRepository.new 
    repo.create(booking)
    redirect '/inbox'
  end

  get '/inbox' do
    repo = UserRepository.new
    @host_all = repo.find_bookings(session[:user_id])
    return erb(:inbox)
  end

  post '/inbox' do
    repo = BookingRepository.new
    approval = params[:approval]
    booking_id = params[:booking_id]
    if approval == 'approved'
      repo.approve(booking_id)
    else
      repo.decline(booking_id)
    end
    redirect '/inbox'
  end

  get '/signup/new' do
    return erb(:signup)
  end
  
  post '/signup' do
    repo = UserRepository.new
    if repo.find_by_email(params[:email]) != nil && repo.find_by_username(params[:username]) != nil
      flash[:notice] = "Email and username already exist."
      redirect '/signup/new'
    elsif repo.find_by_email(params[:email]) != nil
      flash[:notice] = "Email already exists."
      redirect '/signup/new'
    elsif repo.find_by_username(params[:username]) != nil
      flash[:notice] = "Username already exists."
      redirect '/signup/new'
    elsif URI::MailTo::EMAIL_REGEXP.match?(params[:email]) != true
      flash[:notice] = "Please use a valid email."
      redirect '/signup/new'
    else
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
end