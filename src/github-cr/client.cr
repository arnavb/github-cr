require "http/client"
require "./models/user"
require "./errors"
require "json"

module Github
  class Client
    getter user

    def initialize(@username : String, @password : String, user_agent = "github-cr/#{Github::VERSION}", timeout = 15)
      @http_client = HTTP::Client.new(URI.parse(Github::BASE_API_URL))
      @http_client.basic_auth(@username, @password)
      @http_client.connect_timeout = timeout

      http_headers = HTTP::Headers{
        "Accept"     => "application/vnd.github.v3+json",
        "User-Agent" => user_agent,
      }

      client_response = @http_client.get("/user", http_headers)

      raise Github::HTTPError.new(401, "The user was not authenticated!") if client_response.status_code == 401

      @user = Github::User.from_json(client_response.body)
    end

    def finalize
      @http_client.close
    end
  end
end
