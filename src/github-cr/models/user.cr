require "http/client"
require "json"

module GithubCr
  class User
    getter raw_json : Hash(String, JSON::Any)

    def initialize(json_data : String, @http_client : HTTP::Client,
                   @http_headers : HTTP::Headers)
      @raw_json = JSON.parse(json_data).as_h
    end

    def login
      @raw_json["login"]
    end

    def name
      @raw_json["name"]
    end

    def email
      result = raw_json["email"]?
      if result.nil?
        nil
      else
        result.as_s
      end
    end

    def bio
      @raw_json["bio"].as_s
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
      result = raw_json["total_private_repos"]?
      if result.nil?
        nil
      else
        result.as_i
      end
    end

    def num_repos
      if num_private_repos.nil?
        num_public_repos
      else
        num_public_repos + num_private_repos.not_nil!
      end
    end
  end
end
