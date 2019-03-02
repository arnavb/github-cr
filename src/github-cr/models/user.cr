require "http/client"
require "json"

require "./base_model"

module GithubCr
  class User < GithubCr::BaseModel
    def login
      @raw_json["login"]
    end

    def name
      @raw_json["name"]
    end

    def email
      nilable_key("email", &.as_s)
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
      nilable_key("total_private_repos", &.as_i)
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
