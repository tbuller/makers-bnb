require_relative '../lib/booking'
require_relative '../lib/listing'

class BookingRepository 
  def all
    sql = 'SELECT id, date, user_id, listing_id FROM bookings;'
    result_set = DatabaseConnection.exec_params(sql, [])
    bookings = []

    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id'].to_i
      booking.date = record['date']
      booking.user_id = record['user_id'].to_i
      booking.listing_id = record['listing_id'].to_i
    
      bookings << booking 
    end
    return bookings
  end 

  def find(id)
    sql = 'SELECT id, date, user_id, listing_id, approved FROM bookings WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)

    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id'].to_i
      booking.date = record['date']
      booking.user_id = record['user_id'].to_i
      booking.listing_id = record['listing_id'].to_i
      booking.approved = record['approved']
      return booking
    end 
  end 
  
  def create(booking)
    sql = 'INSERT INTO bookings (date, user_id, listing_id, approved) VALUES($1, $2, $3, $4);'
    sql_params = [booking.date, booking.user_id, booking.listing_id, booking.approved]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end

  def approve(booking_id)
    sql = 'UPDATE bookings SET approved = \'t\' WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [booking_id])
  end

  def decline(booking_id)
    sql = 'UPDATE bookings SET approved = \'f\' WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [booking_id])
  end

  def find_listing(booking_id)
    sql = 'SELECT listings.id AS listing_id, name, address, city, country, ppn, bookings.id, date, user_id FROM listings
    JOIN bookings ON listing_id = listings.id
    WHERE bookings.id = $1;'

    result = DatabaseConnection.exec_params(sql, [booking_id])
    
    result.each do |record|
      listing = Listing.new
      listing.id = record['listing_id'].to_i
      listing.name = record['name']
      listing.address = record['address']
      listing.city = record['city']
      listing.country = record['country']
      listing.ppn = record['ppn']
      return listing
    end
  end
end 