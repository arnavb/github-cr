require "http/client"
require "json"

module GithubCr
  class Client
    def initialize(login : String, password : String, base_api_url = "https://api.github.com",
                   user_agent = "github-cr/#{GithubCr::VERSION}", timeout = 15, max_redirects = 5)
      @http_headers = HTTP::Headers{
        "Accept"     => "application/vnd.github.v3+json",
        "User-Agent" => user_agent,
      }
      @http_client = HTTP::Client.new(URI.parse(base_api_url))
      @http_client.connect_timeout = timeout

      @http_client.basic_auth(login, password)
    end

    def user(login : String? = nil)
      response = if login.nil?
                   @http_client.get("/user", @http_headers)
                 else
                   @http_client.get("/users/#{login}", @http_headers)
                 end
      GithubCr.handle_http_errors(response) unless response.success?
      GithubCr::User.new(response.body, @http_client, @http_headers)
    end
  end
end
