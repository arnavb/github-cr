require "http/client"
require "json"

module GithubCr
  class RepositoryOwnerJSON
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
  end

  class RepositoryPermissionsJSON
    include JSON::Serializable

    admin : Bool
    push : Bool
    pull : Bool
  end

  class RepositoryLicenseJSON
    include JSON::Serializable

    getter key : String
    getter name : String
    getter spdx_id : String
    getter url : String
    getter node_id : String
  end

  class RepositoryJSON
    include JSON::Serializable

    getter id : Int32
    getter node_id : String
    getter name : String
    getter full_name : String
    getter owner : RepositoryOwnerJSON
    @[JSON::Field(key: "private")]
    getter priv : Bool
    getter html_url : String
    getter description : String
    getter fork : Bool
    getter url : String
    getter archive_url : String
    getter assignees_url : String
    getter blobs_url : String
    getter branches_url : String
    getter collaborators_url : String
    getter comments_url : String
    getter commits_url : String
    getter compare_url : String
    getter contents_url : String
    getter contributors_url : String
    getter deployments_url : String
    getter downloads_url : String
    getter events_url : String
    getter forks_url : String
    getter git_commits_url : String
    getter git_refs_url : String
    getter git_tags_url : String
    getter git_url : String
    getter issue_comment_url : String
    getter issue_events_url : String
    getter issues_url : String
    getter keys_url : String
    getter labels_url : String
    getter languages_url : String
    getter merges_url : String
    getter milestones_url : String
    getter notifications_url : String
    getter pulls_url : String
    getter releases_url : String
    getter ssh_url : String
    getter stargazers_url : String
    getter statuses_url : String
    getter subscribers_url : String
    getter subscription_url : String
    getter tags_url : String
    getter teams_url : String
    getter trees_url : String
    getter clone_url : String
    getter mirror_url : String
    getter hooks_url : String
    getter svn_url : String
    getter homepage : String
    getter language : String
    getter forks_count : Int32
    getter stargazers_count : Int32
    getter watchers_count : Int32
    getter size : Int32
    getter default_branch : String
    getter open_issues_count : Int32
    getter topics : Array(String)
    getter has_issues : Bool
    getter has_projects : Bool
    getter has_wiki : Bool
    getter has_pages : Bool
    getter has_downloads : Bool
    getter archived : Bool
    getter pushed_at : String
    getter created_at : String
    getter updated_at : String
    getter permissions : RepositoryPermissionsJSON
    getter allow_rebase_merge : Bool
    getter allow_squash_merge : Bool
    getter allow_merge_commit : Bool
    getter subscribers_count : Int32
    getter network_count : Int32
    getter license : RepositoryLicenseJSON?
    getter organization : RepositoryOwnerJSON
    getter parent : RepositoryJSON?
    getter source : RepositoryJSON?
  end
end
