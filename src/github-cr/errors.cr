require "http/client/response"
require "json"

module GithubCr
  class HTTPError < Exception
    getter status_code : Int32
    getter error_message

    def initialize(response : HTTP::Client::Response)
      if response.body?.nil? || response.body.empty?
        @error_message = "An unknown HTTP error occurred!"
      else
        response_message = JSON.parse(response.body)["message"]?
        @error_message = if response_message.nil?
                           "An unknown HTTP error occurred!"
                         else
                           response_message.to_s
                         end
      end

      @status_code = response.status_code

      super("#{@status_code}: #{@error_message}")
    end
  end

  class ResourceNotFoundError < HTTPError
  end

  class NotAuthenticatedError < HTTPError
  end

  class ForbiddenError < HTTPError
  end
end
