require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/listing_repo'
require_relative './lib/database_connection'
require_relative './lib/user_repo'

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

  get '/login' do
    return erb(:login)
  end 
  
  post '/login' do
    repo = UserRepository.new
    
    user = repo.find_by_email(params[:email])
    user_password = user.password
    p user.password
    if repo.valid_password?(user_password, params[:password]) == "success"
      redirect '/'
    else  
      redirect '/login'
    end    
  
  end  
end