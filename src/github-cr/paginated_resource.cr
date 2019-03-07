require "http/client"
require "http/client/response"

require "json"

module GithubCr
  class Page(T)
    include Iterator(T)

    getter json_data : Array(JSON::Any)

    def initialize(json_string : String, @http_client : HTTP::Client, @http_headers : HTTP::Headers)
      @json_data = JSON.parse(json_string).as_a
      @current_position = 0
    end

    def next
      if @current_position < @json_data.size
        object = @json_data[@current_position]
        @current_position += 1
        T.new(object.as_h.to_json, @http_client, @http_headers)
      else
        stop
      end
    end
  end

  class PaginatedResource(T)
    include Iterator(Page(T))

    getter current_response

    def initialize(initial_response : HTTP::Client::Response,
                   @http_client : HTTP::Client, @http_headers : HTTP::Headers)
      @current_response = initial_response
      @finished = false
    end

    def next
      res = Page(T).new(@current_response.body, @http_client, @http_headers)
      link_headers = PaginatedResource.parse_link_headers(@current_response.headers["Link"])
      return stop unless link_headers.has_key?("next")
      response = @http_client.get(link_headers["next"], @http_headers)
      GithubCr.handle_http_errors(response) unless response.success?
      @current_response = response
      res
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
