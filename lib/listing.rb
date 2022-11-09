class Listing
  attr_accessor :id, :name, :address, :city, :country, :ppn, :description, :host_id, :available_start, :available_end

  def initialize 
    @bookings = []
  end

end