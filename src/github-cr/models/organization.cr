require "http/client"
require "json"

module GithubCr
  @[JSON::Serializable::Options(emit_nulls: true)]
  class Organization
    include JSON::Serializable

    getter login : String
    getter id : String
    getter node_id : String
    getter url : String
    getter repos_url : String
    getter events_url : String
    getter hooks_url : String
    getter issues_url : String
    getter members_url : String
    getter public_members_url : String
    getter avatar_url : String
    getter description : String
  end
end
