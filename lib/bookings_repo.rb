require_relative '../lib/bookings'

class BookingRespository 
  def all
    sql = 'SELECT id, date, user_id, listing_id FROM bookings;'
    result_set = DatabaseConnection.exec_params(sql, [])
    bookings = []

    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id'].to_i
      booking.date = record['date']
      booking.user_id = record['user_id']
      booking.listing_id = record['listing_id']
    
      bookings << booking 
    end
    return bookings
  end 

  def find(id)
    sql = 'SELECT id, date, user_id, listing_id FROM bookings WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)

    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id'].to_i
      booking.date = record['date']
      booking.user_id = record['user_id']
      booking.listing_id = record['listing_id']

      return booking
    end 
  end 
  
  def create(booking)
    sql = 'INSERT INTO bookings (date, user_id, listing_id) VALUES($1, $2, $3);'
    sql_params = [booking.date, booking.user_id, booking.listing_id]
    DatabaseConnection.exec_params(sql, sql_params)
    return nil
  end 
end 