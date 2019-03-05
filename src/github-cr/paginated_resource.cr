require "http/client"
require "http/client/response"

module GithubCr
  class PaginatedResource(T)
    getter current_response

    def initialize(initial_response : HTTP::Client::Response,
                   @http_client : HTTP::Client, @http_headers : HTTP::Headers)
      @current_response = initial_response
    end

    def next
      link_headers = PaginatedResource.parse_link_headers(@current_response.headers["Link"])

      if link_headers.has_key?("next")
        response = @http_client.get(link_headers["next"], @http_headers)
        GithubCr.handle_http_errors(response) unless response.success?
        @current_response = response
        T.new(@current_response.body, @http_client, @http_headers)
      end
    end

    def each
      link_headers = PaginatedResource.parse_link_headers(@current_response.headers["Link"])

      while link_headers.has_key?("next")
        response = @http_client.get(link_headers["next"], @http_headers)
        GithubCr.handle_http_errors(response) unless response.success?
        @current_response = response
        yield T.new(@current_response.body, @http_client, @http_headers)
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
