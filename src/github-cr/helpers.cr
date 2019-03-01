require "http/client/response"

module GithubCr
  def self.handle_http_errors(response : HTTP::Client::Response)
    case response.status_code
    when 401
      raise GithubCr::NotAuthenticatedError.new(response)
    when 403
      raise GithubCr::ForbiddenError.new(response)
    when 404
      raise GithubCr::ResourceNotFoundError.new(response)
    else
      raise GithubCr::HTTPError.new(response)
    end
  end
end
