require "http/client"
require "json"

require "./base_model"

module GithubCr
  class User < GithubCr::BaseModel
    def login
      @raw_json["login"].as_s
    end

    def name
      @raw_json["name"].as_s?
    end

    def name=(new_name : String)
      patch_user({"name" => new_name})
    end

    def email
      @raw_json["email"].as_s?
    end

    def bio
      @raw_json["bio"].as_s?
    end

    def blog
      @raw_json["blog"].as_s?
    end

    def company
      @raw_json["company"].as_s?
    end

    def location
      @raw_json["location"].as_s?
    end

    def hireable?
      @raw_json["hireable"].as_bool?
    end

    def num_followers
      @raw_json["followers"].as_i
    end

    def num_following
      @raw_json["following"].as_i
    end

    def num_public_repos
      @raw_json["public_repos"].as_i
    end

    def num_private_repos
      if @raw_json["total_private_repos"]?.nil?
        nil
      else
        @raw_json["total_private_repos"].not_nil!.as_i
      end
    end

    def num_repos
      if num_private_repos.nil?
        num_public_repos
      else
        num_public_repos + num_private_repos.not_nil!
      end
    end

    def patch_user(new_body : Hash(String, String))
      response = @http_client.patch("/user", @http_headers,
        body: new_body.to_json)
      GithubCr.handle_http_errors(response) unless response.success?
      @raw_json = JSON.parse(response.body).as_h
    end
  end
end
