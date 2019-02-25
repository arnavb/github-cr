# require "http/client"
require "halite"
require "./models/user"
require "./errors"
require "json"

module Github
  class Client
    getter user

    def initialize(username : String, password : String, user_agent = "github-cr/#{Github::VERSION}",
                   timeout = 15, max_redirects = 5)
      # Initialize Halite HTTP Client for all subsequent requests
      @http_client = Halite::Client.new do
        basic_auth username, password
        headers accept: "application/vnd.github.v3+json"
        headers user_agent: user_agent
        timeout timeout
        follow max_redirects
      end

      client_response = @http_client.get("#{Github::BASE_API_URL}/user")

      raise Github::HTTPError.new(401, "The user was not authenticated!") if client_response.status_code == 401

      @user = Github::User.from_json(client_response.body)
    end
  end
end
