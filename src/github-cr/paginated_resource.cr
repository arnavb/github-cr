require "http/client"
require "http/client/response"

require "json"

module GithubCr
  class Page(T)
    getter json_data : Array(JSON::Any)

    def initialize(json_string : String, @http_client : HTTP::Client, @http_headers : HTTP::Headers, @complete_request = false)
      @json_data = JSON.parse(json_string).as_a
    end

    def each
      @json_data.each do |object|
        if @complete_request
          url = object["url"].as_s
          response = @http_client.get(url, @http_headers)
          GithubCr.handle_http_errors(response) unless response.success?
          yield T.new(response.body, @http_client, @http_headers)
        else
          yield T.new(object.as_h.to_json, @http_client, @http_headers)
        end
      end
    end
  end

  class PaginatedResource(T)
    getter current_response

    def initialize(initial_response : HTTP::Client::Response,
                   @http_client : HTTP::Client, @http_headers : HTTP::Headers, @complete_request = false)
      @current_response = initial_response
    end

    def each
      link_headers = PaginatedResource.parse_link_headers(@current_response.headers["Link"])

      loop do
        yield Page(T).new(@current_response.body, @http_client, @http_headers, @complete_request)
        break unless link_headers.has_key?("next")
        response = @http_client.get(link_headers["next"], @http_headers)
        GithubCr.handle_http_errors(response) unless response.success?
        @current_response = response
        link_headers = PaginatedResource.parse_link_headers(@current_response.headers["Link"])
      end
    end

    def self.parse_link_headers(link_headers : String)
      result = {} of String => String
      link_headers.split(",").map(&.strip).each do |link|
        parts = link.split(";").map(&.strip)
        url_match = parts[0].match(/<(.*)>/)

        url = ""
        if url_match
          url = url_match[1]
        end

        rel_match = parts[1].match(/rel=\"(.*)\"/)
        rel = ""
        if rel_match
          rel = rel_match[1]
        end

        result[rel] = url
      end
      result
    end
  end
end
