class Listing
  attr_accessor :id, :name, :address, :city, :country, :ppn, :description, :host_id, :available_start, :available_end, :bookings, :stays

  def initialize 
    @bookings = []
    @stays = []
  end 

  
end
