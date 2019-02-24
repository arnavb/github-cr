require "http/client"

module Github
  class Client
    def initialize(@username : String, @password : String?)

    end
  end
end
