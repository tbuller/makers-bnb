require_relative '../lib/listing_repo'
require_relative '../lib/database_connection'

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
end