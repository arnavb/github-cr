require "http/client"
require "json"

module GithubCr
  class User
    class UserPlanJSON
      include JSON::Serializable

      getter name : String
      getter space : Int32
      getter private_repos : Int32
      getter collaborators : Int32
    end

    @[JSON::Serializable::Options(emit_nulls: true)]
    class UserJSON
      include JSON::Serializable

      getter login : String
      getter id : Int32
      getter node_id : String
      getter avatar_url : String
      getter gravatar_id : String
      getter url : String
      getter html_url : String
      getter followers_url : String
      getter following_url : String
      getter gists_url : String
      getter starred_url : String
      getter subscriptions_url : String
      getter organizations_url : String
      getter repos_url : String
      getter events_url : String
      getter received_events_url : String
      getter type : String
      getter site_admin : Bool
      getter name : String
      getter company : String?
      getter blog : String
      getter location : String
      getter email : String?
      getter hireable : Bool?
      getter bio : String
      getter public_repos : Int32
      getter public_gists : Int32
      getter followers : Int32
      getter following : Int32
      getter created_at : String
      getter updated_at : String
      getter private_gists : Int32?
      getter total_private_repos : Int32?
      getter owned_private_repos : Int32?
      getter disk_usage : Int32?
      getter collaborators : Int32?
      getter two_factor_authentication : Bool?
      getter plan : UserPlanJSON?
    end

    getter raw_json

    # Some helper attributes so they can be accessed from object itself
    delegate login, name, email, bio, to: @raw_json

    def initialize(json_data : String, @http_client : HTTP::Client,
                   @http_headers : HTTP::Headers)
      @raw_json = UserJSON.from_json(json_data)
    end
  end
end
