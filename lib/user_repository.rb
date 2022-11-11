require_relative 'user'
require_relative 'booking'
require_relative 'listing'
require_relative 'booking_repository'
require_relative 'listing_repository'
require 'bcrypt'

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
    listing_with_bookings = []
    listing_repo = ListingRepository.new

    host.listings.each do |listing|
     listing = listing_repo.find_bookings(listing.id)
     listing_with_bookings << listing

     host.bookings << listing.bookings
    end

     host.listings = listing_with_bookings

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

    if result_set.values.empty?
      return nil 
    else
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
  end  

  def valid_password?(db_password, submitted_password)
    if submitted_password == db_password
      return "success"
    else
      return "failure"
    end  
  end

  def find_by_username(username)
    sql = 'SELECT * FROM users WHERE username = $1;'
    result_set = DatabaseConnection.exec_params(sql, [username])

    if result_set.values.empty?
      return nil 
    else
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
  end

  def invalid_login_parameters?(email, password)
    email.match(/<.+>/) || 
    email.start_with?('<') || 
    email == "" || 
    password.match(/<.+>/) ||
    password.start_with?('<') ||
    password == "" ? true : false
  end

  def find_bookings_by_user(user_id)
    sql = 'SELECT users.id AS user_id, users.name AS user_name, users.username,
     users.email, bookings.id AS booking_id,
    bookings.date AS booking_date, bookings.user_id, bookings.listing_id,
    listings.name AS listing_name, city AS listing_city, country AS listing_country, 
    ppn AS listing_ppn FROM users
    JOIN bookings ON user_id = users.id
    JOIN listings ON listing_id = listings.id 
    WHERE users.id = $1;'

    result = DatabaseConnection.exec_params(sql, [user_id])

    @user = User.new
    result.each do |record|
      booking = Booking.new
      listing = Listing.new
      @user.id = record['user_id'].to_i
      @user.name = record['user_name']
      @user.username = record['username']
      @user.email = record['email']
      booking.id = record['booking_id']
      booking.date = record['booking_date'] 
      listing.name = record['listing_name']
      listing.city = record['listing_city']
      listing.country = record['listing_country']
      listing.ppn = record['listing_ppn']

      @user.stays << booking

      booking_repo = BookingRepository.new

      @user.stays.each do |booking|
        listing = booking_repo.find_listing(booking.id)
        listing.stays << booking
        @user.stay_listings << listing
      end

    end

   return @user
  end

end
