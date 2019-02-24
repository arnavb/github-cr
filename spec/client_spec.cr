require "./spec_helper"

describe Github::Client do
  describe "#new" do
    context "when user is authenticated" do
      it "gets the client user" do
        WebMock.stub(:get, "https://api.github.com/user")

        client = Github::Client.new("some_username", "str0nG_PaSsWorD")

        client.user.should eq 200
      end
    end

    context "when user provides custom user agent" do
      it "gets the client user" do
        WebMock.stub(:get, "https://api.github.com/user")
          .with(headers: {"User-Agent" => "MyApplication/1.2.3"})

        client = Github::Client.new("some_username", "str0nG_PaSsWorD", user_agent = "MyApplication/1.2.3")

        client.user.should eq 200
      end
    end

    context "when user credentials are invalid" do
      it "returns a 401" do
        WebMock.stub(:get, "https://api.github.com/user")
          .to_return(status: 401)

        client = Github::Client.new("some_username", "str0nG_PaSsWorD")

        client.user.should eq 401
      end
    end

    context "when user agent string is missing" do
      it "returns a 401" do
        WebMock.stub(:get, "https://api.github.com/user")
          .with(headers: {"User-Agent" => ""})
          .to_return(status: 401)

        client = Github::Client.new("some_username", "str0nG_PaSsWorD", user_agent = "")

        client.user.should eq 401
      end
    end
  end
end
