require "http/client"

module Github
  class Client
    def initialize(@username : String, @password : String, user_agent = "github-cr/#{Github::VERSION}", timeout = 15)
      @http_client = HTTP::Client.new(URI.parse(Github::BASE_API_URL))
      @http_client.basic_auth(@username, @password)
      @http_client.connect_timeout = timeout

      @http_headers = HTTP::Headers{
        "Accept"     => "application/vnd.github.v3+json",
        "User-Agent" => user_agent,
      }
      # @user =
    end

    def user
      response = @http_client.get("/user", @http_headers)
      response.status_code
    end

    def finalize
      @http_client.close
    end
  end
end
