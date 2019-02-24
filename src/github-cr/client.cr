require "http/client"

module Github
  class Client
    def initialize(@username : String, @password : String)
      @http_client = HTTP::Client.new(URI.parse(Github::BASE_API_URL))
      @http_client.basic_auth(@username, @password)
    end

    def user
      response = @http_client.get("/user")
      response.status_code
    end

    def finalize
      @http_client.close
    end
  end
end
