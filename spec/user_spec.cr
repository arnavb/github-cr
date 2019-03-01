require "http/client"
require "json"

require "./spec_helper"

def mock_http
  HTTP::Client.new(URI.parse("https://api.github.com"))
end

def mock_headers
  HTTP::Headers{
    "Accept"     => "application/vnd.github.v3+json",
    "User-Agent" => "github-cr/#{GithubCr::VERSION}",
  }
end

describe GithubCr::User do
  describe "#new" do
    it "works with client user" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.raw_json.plan.should_not be_nil
    end

    it "works with other users" do
      user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
      user.raw_json.plan.should be_nil
    end
  end

  describe "#raw_json" do
    it "contains raw response JSON" do
      json_data = get_json("client_user.json")

      user = GithubCr::User.new(json_data, mock_http, mock_headers)

      user.raw_json.to_json.should eq JSON.parse(json_data).to_json
    end

    it "allows access of JSON as attributes" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)

      user.raw_json.login.should eq "octocat"
      user.raw_json.plan.not_nil!.space.should eq 400
    end
  end

  it "makes some helper attributes available at top level" do
    user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)

    user.login.should eq user.raw_json.login
    user.name.should eq user.raw_json.name
    user.email.should eq user.raw_json.email
    user.bio.should eq user.raw_json.bio
  end

  describe "#num_followers" do
    it "returns the number of followers" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.num_followers.should eq user.raw_json.followers
    end
  end

  describe "#num_followers" do
    it "returns the number of following" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.num_following.should eq user.raw_json.following
    end
  end
end
