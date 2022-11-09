class User
  attr_accessor :id, :name, :username, :email, :password, :listings, :bookings

  def initialize
    @listings = []
    @bookings = []
  end
end