require_relative 'user'

class UserRepository
  def all
    users = []

    sql = 'SELECT * FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    result_set.each do |record|

      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      users << user
    end

    return users
  end

  def find(id)
    sql = 'SELECT * FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      return user
    end
  end

  def create(user)
    sql = 'INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4);'
    result_set = DatabaseConnection.exec_params(sql, [user.name, user.username, user.email, user.password])
    
    return user
  end

  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])

    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      return user
    end
  end  

  def valid_password?(password, submitted_password)
    
    if password == submitted_password
      return "success"
    else
      return "failure"  
    end  
  end  
end
