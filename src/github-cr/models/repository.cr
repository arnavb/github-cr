require "./base_model"

module GithubCr
  class Repository < GithubCr::BaseModel
    def name
      @raw_json["name"].as_s
    end

    def slug
      @raw_json["full_name"].as_s
    end

    def owner : GithubCr::User | GithubCr::Organization
      response = @http_client.get(%(/users/#{@raw_json["owner"]["login"].as_s}), @http_headers)
      GithubCr.handle_http_errors(response) unless response.success?
      if @raw_json["owner"]["type"].as_s == "User"
        GithubCr::User.new(response.body, @http_client, @http_headers, false)
      else
        GithubCr::Organization.new(response.body, @http_client, @http_headers)
      end
    end
  end
end
