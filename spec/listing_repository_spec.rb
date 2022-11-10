require_relative '../lib/listing_repository'
require_relative '../lib/database_connection'
require_relative '../lib/listing'

def reset_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do
    reset_table
  end

  it 'returns all listings' do
    repo = ListingRepository.new
    listings = repo.all
    expect(listings.length).to eq 6
    expect(listings[2].name).to eq('Flashy mansion')
    expect(listings[5].city).to eq('Hamburg')
    expect(listings[5].host_id).to eq(3)
  end

  context 'returns a listing by ID' do
    it 'listing 5' do
      repo = ListingRepository.new
      listing = repo.find(5)
      expect(listing.name).to eq('Lovers first choice')
      expect(listing.ppn).to eq('$760.00')
      expect(listing.city).to eq('Paris')
    end

    it 'listing 2' do
      repo = ListingRepository.new
      listing = repo.find(2)
      expect(listing.name).to eq('Pokey underground bedsit')
      expect(listing.ppn).to eq('$79.00')
      expect(listing.city).to eq('New York')
    end
  end

  it 'creates new listing' do
    listing = Listing.new
    listing.name = 'Santorini escape'
    listing.address = '52 Italy Street'
    listing.city = 'Sao Paolo'
    listing.country = 'Mexico'
    listing.ppn = '$1,000.00'
    listing.description = 'As advertised'
    listing.host_id = 3
    repo = ListingRepository.new
    repo.create(listing)
    expect(listing.address).to eq('52 Italy Street')
    expect(listing.city).to eq('Sao Paolo')
    expect(listing.country).to eq('Mexico')
  end

  it 'returns bookings for listing ID 2' do
    repo = ListingRepository.new
    listing = repo.find_bookings(2)
    expect(listing.bookings.length).to eq(1)
    expect(listing.bookings.first.date).to eq('2022-03-01')
    expect(listing.bookings.first.user_id).to eq(2)
  end 
  
  it 'returns an array of dates less the dates that have been approved' do
    repo = ListingRepository.new
    dates_available = repo.give_date_range(5)
    dates_available2 = repo.give_date_range(7)

    expect(dates_available).to eq ["2022-12-26", "2022-12-27", "2022-12-28", "2022-12-29", "2022-12-30", "2022-12-31", "2023-01-01", "2023-01-02"]
    expect(dates_available2).to eq ["2022-11-12", "2022-11-13", "2022-11-15", "2022-11-17", "2022-11-18"]

  end 
  
end