require "./models/user"

# Definition of endpoints not requiring authentication

module Github
  def self.get_user(username : String) : User
  end
end
