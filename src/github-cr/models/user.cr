require "json"

module GithubCr
  class UserPlan
    JSON.mapping({
      name:          String,
      space:         Int32,
      private_repos: Int32,
      collaborators: Int32,
    })
  end

  class User
    JSON.mapping({
      login:                     String,
      id:                        Int32,
      node_id:                   String,
      avatar_url:                String,
      gravatar_id:               String,
      url:                       String,
      html_url:                  String,
      followers_url:             String,
      following_url:             String,
      gists_url:                 String,
      starred_url:               String,
      subscriptions_url:         String,
      organizations_url:         String,
      repos_url:                 String,
      events_url:                String,
      received_events_url:       String,
      type:                      String,
      site_admin:                Bool,
      name:                      String,
      company:                   String,
      blog:                      String,
      location:                  String,
      email:                     String?,
      hireable:                  Bool,
      bio:                       String,
      public_repos:              Int32,
      public_gists:              Int32,
      followers:                 Int32,
      following:                 Int32,
      created_at:                String,
      updated_at:                String,
      private_gists:             Int32?,
      total_private_repos:       Int32?,
      owned_private_repos:       Int32?,
      disk_usage:                Int32?,
      collaborators:             Int32?,
      two_factor_authentication: Bool?,
      plan:                      {type: UserPlan, nilable: true},
    })
  end
end
