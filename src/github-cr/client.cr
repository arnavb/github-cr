# require "http/client"
require "halite"
require "./models/user"
require "./errors"
require "json"

module GithubCr
  class Client
    def initialize(login : String, password : String, user_agent = "github-cr/#{GithubCr::VERSION}",
                   timeout = 15, max_redirects = 5)
      # Initialize Halite HTTP Client for all subsequent requests
      @http_client = Halite::Client.new do
        basic_auth login, password
        headers accept: "application/vnd.github.v3+json"
        headers user_agent: user_agent
        timeout timeout
        follow max_redirects
      end

      response = @http_client.get("#{GithubCr::BASE_API_URL}/user")

      raise GithubCr::HTTPError.new(401, "The user was not authenticated!") if response.status_code == 401

      @user = GithubCr::User.from_json(response.body)
    end

    def user(login : String? = nil)
      if login.nil?
        @user
      else
        response = @http_client.get("#{GithubCr::BASE_API_URL}/users/#{login}")
        GithubCr::User.from_json(response.body)
      end
    end
  end
end
