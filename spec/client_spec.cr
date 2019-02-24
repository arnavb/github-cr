require "./spec_helper"

describe Github::Client do
  describe "#new" do
    context "when user is authenticated" do
      it "gets the client user" do
        json_body = File.read("#{__DIR__}/mocked-json/client_user.json")

        WebMock.stub(:get, "https://api.github.com/user")
          .to_return(status: 200, body: json_body)

        client = Github::Client.new("octocat", "")

        client.user.should be_a Github::User
        client.user.to_json.should eq JSON.parse(json_body).to_json
      end

      it "can access JSON attributes" do
        json_string = File.read("#{__DIR__}/mocked-json/client_user.json")

        WebMock.stub(:get, "https://api.github.com/user")
          .to_return(status: 200, body: json_string)

        client = Github::Client.new("octocat", "octocat_password")

        client.user.login.should eq "octocat"
        client.user.hireable.should eq false
      end
    end

    context "when user provides custom user agent" do
      it "gets the client user" do
        json_body = File.read("#{__DIR__}/mocked-json/client_user.json")

        WebMock.stub(:get, "https://api.github.com/user")
          .with(headers: {"User-Agent" => "MyApplication/1.2.3"})
          .to_return(status: 200, body: json_body)

        client = Github::Client.new("octocat", "octocat_password", user_agent = "MyApplication/1.2.3")

        client.user.class.should eq Github::User
        client.user.to_json.should eq JSON.parse(json_body).to_json
      end
    end

    context "when user credentials are invalid" do
      it "returns a 401" do
        WebMock.stub(:get, "https://api.github.com/user")
          .to_return(status: 401)

        exception = expect_raises Github::HTTPError do
          client = Github::Client.new("octocat", "blah_blah")
        end

        exception.status_code.should eq 401
      end
    end

    context "when user agent string is missing" do
      it "returns a 401" do
        WebMock.stub(:get, "https://api.github.com/user")
          .with(headers: {"User-Agent" => ""})
          .to_return(status: 401)

        exception = expect_raises Github::HTTPError do
          client = Github::Client.new("octocat", "octocat_password", user_agent = "")
        end

        exception.status_code.should eq 401
      end
    end
  end
end
