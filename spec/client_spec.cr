require "./spec_helper"

describe Github::Client do
  context "user exists" do
    it "gets the client user" do
      WebMock.stub(:any, "https://api.github.com/user")
      client = Github::Client.new("some_username", "str0nG_PaSsWorD")

      client.user.should eq 200
    end
  end

  context "user not authenticated" do
    it "returns a 401" do
      WebMock.stub(:get, "https://api.github.com/user")
        .to_return(status: 401)
      client = Github::Client.new("some_username", "str0nG_PaSsWorD")

      client.user.should eq 401
    end
  end
end
