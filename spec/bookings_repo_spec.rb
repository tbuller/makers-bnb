require_relative '../lib/bookings_repository'
 
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
end