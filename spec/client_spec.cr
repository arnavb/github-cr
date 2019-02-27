require "./spec_helper"

describe GithubCr::Client do
  describe "#user" do
    context "when user is authenticated" do
      context "when login isn't passed" do
        it "returns the client user" do
          json_body = File.read("#{__DIR__}/mocked-json/client_user.json")

          WebMock.stub(:get, "https://api.github.com/user")
            .with(headers: {"Accept"     => "application/vnd.github.v3+json",
                            "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
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
            .with(headers: {"Accept"     => "application/vnd.github.v3+json",
                            "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
            .to_return(status: 200, body: json_body)
          client = GithubCr::Client.new("octocat", "octocat_password")

          octocat_user = client.user("octocat")

          octocat_user.should be_a GithubCr::User
          octocat_user.name.should eq "monalisa octocat"
        end
      end
    end
  end
end
