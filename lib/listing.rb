class Listing
  attr_accessor :id, :name, :address, :city, :country, :ppn, :description, :host_id

  def initialize 
    @bookings = []
  end

end