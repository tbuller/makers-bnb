require_relative '../lib/booking_repository'
require_relative '../lib/database_connection'
 
def reset_bookings_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe BookingRepository do 

  before(:each) do 
    reset_bookings_table
  end 

  it 'returns the first of the list of bookings' do 
    repo = BookingRepository.new 
    
    booking = repo.all

    expect(booking.length).to eq(6)
    expect(booking.first.id).to eq(1)
    expect(booking.first.date).to eq ('2022-05-01')
    expect(booking.first.user_id).to eq(1)
    expect(booking.first.listing_id).to eq(1)
  end 

  it 'returns a single booking and info from id = "1"' do 
    repo = BookingRepository.new
    booking = repo.find(1)
    expect(booking.date).to eq('2022-05-01')
    expect(booking.user_id).to eq(1)
    expect(booking.listing_id).to eq(1)
   end 

  it 'creates a new booking' do 
    repo = BookingRepository.new 

    booking = Booking.new 
    booking.date = '2022-06-06'
    booking.user_id = 2
    booking.listing_id = 6

    repo.create(booking)
    
    bookings = repo.all

    last_booking = bookings.last
    expect(last_booking.date).to eq '2022-06-06'
    expect(last_booking.listing_id).to eq 6
  end 

  it "updates the booking with id = 1 to true" do
    repo = BookingRepository.new
    repo.approve(1)
    booking = repo.find(1)
    expect(booking.approved).to eq "true"
  end 

  it "updates the booking with id 6 to false" do
    repo = BookingRepository.new
    repo.decline(6)
    booking = repo.find(6)
    expect(booking.approved).to eq "false"
  end 
end