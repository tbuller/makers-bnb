class User
  attr_accessor :id, :name, :username, :email, :password, :listings, :bookings, :stays, :stay_listings

  def initialize
    @listings = []
    @bookings = []
    @stays = []
    @stay_listings = []
  end
end