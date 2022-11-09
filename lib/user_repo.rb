require_relative 'user'
require_relative 'bookings'
require_relative 'bookings_repository'
require_relative 'listing_repo'

class UserRepository
  def all
    users = []

    sql = 'SELECT * FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    result_set.each do |record|

      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      users << user
    end

    return users
  end

  def find(id)
    sql = 'SELECT * FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      return user
    end
  end

  def find_listings(host_id)
    sql = 'SELECT users.id AS host_id, users.name AS host_name, username, email, listings.id AS listing_id, listings.name AS listing_name, address, city, country, ppn, description, available_start, available_end FROM users
    JOIN listings ON host_id = users.id
    WHERE users.id = $1;'

    result_set = DatabaseConnection.exec_params(sql, [host_id])
    user = User.new
    result_set.each do |record|
      
      user.id = record['host_id'].to_i
      user.name = record['host_name']
      user.username = record['username']
      user.email = record['email']
      
      listing = Listing.new
      listing.id = record['listing_id'].to_i
      listing.name = record['listing_name']
      listing.address = record['address']
      listing.city = record['city']
      listing.country = record['country']
      listing.ppn = record['ppn']
      listing.description = record['description']
      listing.host_id = record['host_id'].to_i
      listing.available_start = record['available_start']
      listing.available_end = record['available_end']

      user.listings << listing
    end
    return user
  end

  def find_bookings(host_id)
    host = find_listings(host_id)
    listings = host.listings

    listing_repo = ListingRepository.new
    listings.each do |listing|
     listing = listing_repo.find_bookings(listing.id)
     host.bookings << listing.bookings
    end
      host.bookings = host.bookings.flatten
    return host
  end

  def create(user)
    sql = 'INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4);'
    result_set = DatabaseConnection.exec_params(sql, [user.name, user.username, user.email, user.password])
    
    return user
  end

  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])

    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      return user
    end
  end  

  def valid_password?(password, submitted_password)
    
    if password == submitted_password
      return "success"
    else
      return "failure"  
    end  
  end  
end
