# require "http/client"
require "halite"
require "./models/user"
require "./errors"
require "json"

module GithubCr
  class Client
    def initialize(login : String, password : String, @base_api_url = "https://api.github.com",
                   user_agent = "github-cr/#{GithubCr::VERSION}", timeout = 15, max_redirects = 5)
      # Initialize Halite HTTP Client for all subsequent requests
      @http_client = Halite::Client.new do
        basic_auth login, password
        headers accept: "application/vnd.github.v3+json"
        headers user_agent: user_agent
        timeout timeout
        follow max_redirects
      end
    end

    def user(login : String? = nil)
      response = if login.nil?
                   @http_client.get("#{@base_api_url}/user")
                 else
                   @http_client.get("#{@base_api_url}/users/#{login}")
                 end
      GithubCr::User.new(response.body, @http_client, @base_api_url)
    end
  end
end
