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
      user.raw_json.has_key?("plan").should be_true
    end

    it "works with other users" do
      user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
      user.raw_json.has_key?("plan").should_not be_true
    end
  end

  describe "#raw_json" do
    it "contains raw response JSON" do
      json_data = get_json("client_user.json")

      user = GithubCr::User.new(json_data, mock_http, mock_headers)

      user.raw_json.should eq JSON.parse(json_data)
    end
  end

  describe "#login" do
    it "returns the user's login" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.login.should eq user.raw_json["login"]
    end
  end

  describe "#name" do
    it "returns the user's name" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.name.should eq user.raw_json["name"]
    end
  end

  describe "#email" do
    it "returns the user's email" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.email.should eq user.raw_json["email"]
    end
  end

  describe "#bio" do
    it "returns the user's bio" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.bio.should eq user.raw_json["bio"]
    end
  end

  describe "#blog" do
    it "returns the user's blog" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.blog.should eq user.raw_json["blog"]
    end
  end

  describe "#company" do
    it "returns the user's company" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.company.should eq user.raw_json["company"]
    end
  end

  describe "#location" do
    it "returns the user's blog" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.location.should eq user.raw_json["location"]
    end
  end

  describe "#hireable?" do
    it "returns whether the user is hireable" do
    end
  end

  describe "#num_followers" do
    it "returns the number of followers" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.num_followers.should eq user.raw_json["followers"]
    end
  end

  describe "#num_followers" do
    it "returns the number of following" do
      user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
      user.num_following.should eq user.raw_json["following"]
    end
  end

  describe "#num_public_repos" do
    it "returns the total number of public repositories" do
      user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
      user.num_public_repos.should eq user.raw_json["public_repos"]
    end
  end

  describe "#num_private_repos" do
    context "when user is the client" do
      it "returns the total number of private repositories" do
        user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
        user.num_private_repos.should eq user.raw_json["total_private_repos"]
      end
    end

    context "when user is not the client" do
      it "returns nil" do
        user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
        user.num_private_repos.should be_nil
      end
    end
  end

  describe "#num_repos" do
    context "when user is the client" do
      it "returns the total number of public/private repositories" do
        user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
        user.num_repos.should eq user.num_public_repos + user.num_private_repos.not_nil!
      end
    end

    context "when user is not the client" do
      it "returns the total number of public repositories" do
        user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
        user.num_repos.should eq user.num_public_repos
      end
    end
  end

  describe "#patch" do
    context "when user is the client" do
      it "allows patching of user attributes" do
        WebMock.stub(:patch, "https://api.github.com/user")
          .with(body: %({"name":"something else"}), headers: {"Accept"     => "application/vnd.github.v3+json",
                                                              "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
          .to_return(status: 200, body: get_json("patched_user.json"))

        user = GithubCr::User.new(get_json("client_user.json"), mock_http, mock_headers)
        user.name.should eq "monalisa octocat"

        user.patch(name: "something else")

        user.name.should eq "something else"
        user.raw_json["name"].should eq "something else"
      end
    end

    context "when user is not the client" do
      it "raises a GithubCr::NotAuthenticatedError" do
        WebMock.stub(:patch, "https://api.github.com/user")
          .with(body: %({"name":"something else"}), headers: {"Accept"     => "application/vnd.github.v3+json",
                                                              "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
          .to_return(status: 401)
        user = GithubCr::User.new(get_json("other_user.json"), mock_http, mock_headers)
        user.name.should eq "monalisa octocat"

        expect_raises(GithubCr::NotAuthenticatedError) do
          user.patch(name: "something else")
        end

        user.name.should eq "monalisa octocat"
      end
    end
  end
end
