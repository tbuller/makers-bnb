require_relative 'listing'

class ListingRepository
  def all
    sql = 'SELECT * FROM listings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    listings = []
    result_set.each do |record|
      listing = Listing.new
      listing.id = record['id'].to_i
      listing.name = record['name']
      listing.address = record['address']
      listing.city = record['city']
      listing.country = record['country']
      listing.ppn = record['ppn']
      listing.description = record['description']
      listing.host_id = record['host_id'].to_i
      listings << listing
    end
    
    return listings
  end

  def find(id)
    sql = 'SELECT * FROM listings WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    result_set.each do |record|
      listing = Listing.new
      listing.id = record['id']
      listing.name = record['name']
      listing.address = record['address']
      listing.city = record['city']
      listing.country = record['country']
      listing.ppn = record['ppn']
      listing.description = record['description']
      listing.host_id = record['host_id']

      return listing
    end

    
  end

end