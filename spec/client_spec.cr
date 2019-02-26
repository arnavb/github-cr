require "./spec_helper"

describe GithubCr::Client do
  describe "#user" do
    context "when user is authenticated" do
      context "when login isn't passed" do
        it "returns the client user" do
          json_body = File.read("#{__DIR__}/mocked-json/client_user.json")

          WebMock.stub(:get, "https://api.github.com/user")
            .to_return(status: 200, body: json_body)

          client = GithubCr::Client.new("octocat", "octocat_password")

          client.user.should be_a GithubCr::User
          client.user.name.should eq "monalisa octocat"
        end
      end

      context "when login is passed" do
        it "returns the corresponding Github user" do
          json_body = File.read("#{__DIR__}/mocked-json/other_user.json")

          WebMock.stub(:get, "https://api.github.com/users/octocat")
            .to_return(status: 200, body: json_body)
          client = GithubCr::Client.new("octocat", "octocat_password")

          client.user("octocat").should be_a GithubCr::User
          client.user("octocat").name.should eq "monalisa octocat"
        end
      end
    end
  end
end
