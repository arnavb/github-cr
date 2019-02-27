require "http/client/response"

module GithubCr
  def self.handle_http_errors(response : HTTP::Client::Response)
    p response.body
    raise GithubCr::HTTPError.new(response.status_code,
      JSON.parse(response.body)["message"].to_s)
  end
end
