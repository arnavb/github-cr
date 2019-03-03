require "http/client/response"
require "json"

module GithubCr
  class BaseModel
    getter raw_json : Hash(String, JSON::Any)

    protected def initialize(json_data : String, @http_client : HTTP::Client,
                             @http_headers : HTTP::Headers)
      @raw_json = JSON.parse(json_data).as_h
    end
  end
end
