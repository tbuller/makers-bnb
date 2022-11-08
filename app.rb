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

  get '/booking/new' do 
    
  return erb(:new_booking)
  end 
end