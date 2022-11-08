require_relative '../lib/user_repo'

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
end