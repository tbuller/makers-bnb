class User
  attr_accessor :id, :name, :username, :email, :password, :listings

  def initialize
    @listings = []
  end
end