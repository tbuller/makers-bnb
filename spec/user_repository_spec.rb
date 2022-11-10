require_relative '../lib/user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do

  before(:each) do 
    reset_users_table
  end


  it "returns all users" do
    repo = UserRepository.new
    users = repo.all

    expect(users.length).to eq(3)
    expect(users.first.id).to eq(1)
    expect(users.last.name).to eq('The Rock')
  end

  it "finds a single user" do
    repo = UserRepository.new
    user = repo.find(2)
    expect(user.id).to eq(2)
    expect(user.name).to eq('Stone Cold Steve Austin')
    expect(user.username).to eq('stonecoldstunner')
  end

  it "finds a single user" do
    repo = UserRepository.new
    user = repo.find(3)
    expect(user.id).to eq(3)
    expect(user.name).to eq('The Rock')
    expect(user.username).to eq('peopleseyebrow')
  end

  it "creates a new user" do
    repo = UserRepository.new

    new_user = User.new
    new_user.name = 'Mankind'
    new_user.username = 'mrsocko'
    new_user.email = 'mandibleclaw@weemail.com'
    new_user.password = 'Password'

    repo.create(new_user)

    users = repo.all

    expect(users.length).to eq(4)
    expect(users.last.id).to eq(4)
    expect(users.last.name).to eq('Mankind')
    expect(users.last.username).to eq('mrsocko')
    expect(users.last.email).to eq('mandibleclaw@weemail.com')
    expect(users.last.password).to eq('Password')
  end

  it 'finds a user based on the email' do
    repo = UserRepository.new
    user = repo.find_by_email('champ@weemail.com')
    expect(user.id).to eq 3
  end  

  it 'finds listings for user ID 3' do
    repo = UserRepository.new
    user = repo.find_listings(3)
    expect(user.listings.length).to eq(2)
    expect(user.listings.first.city).to eq('Oslo')
    expect(user.listings.last.ppn).to eq('$40.00')
    expect(user.listings.last.country).to eq('Germany')
  end

  it 'finds bookings for user ID 2' do
    repo = UserRepository.new
    user = repo.find_bookings(2)
    expect(user.bookings.length).to eq(2)
    expect(user.bookings.first.id).to eq(2)
    expect(user.bookings.last.date).to eq('2022-12-25')
  end

end