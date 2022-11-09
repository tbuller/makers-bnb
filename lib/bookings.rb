class Booking
  attr_accessor :id, :date, :user_id, :listing_id, :approved

  def initialize
    @approved = false
  end
end 