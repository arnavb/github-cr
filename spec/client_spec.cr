require "./spec_helper"

describe GithubCr::Client do
  describe "#user" do
    context "when user is authenticated" do
      context "when login isn't passed" do
        it "returns the client user" do
          json_body = File.read("#{__DIR__}/mocked_json/client_user.json")

          WebMock.stub(:get, "https://api.github.com/user")
            .with(headers: {"Accept"     => "application/vnd.github.v3+json",
                            "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
            .to_return(status: 200, body: json_body)

          client = GithubCr::Client.new("octocat", "octocat_password")

          client_user = client.user

          client_user.should be_a GithubCr::User
          client_user.name.should eq "monalisa octocat"
        end
      end

      context "when login is passed" do
        it "returns the corresponding Github user" do
          json_body = File.read("#{__DIR__}/mocked_json/other_user.json")

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

    context "when user is not authenticated" do
      context "when login is not passed" do
        context "when user agent string is invalid" do
          it "raises GithubCr::HTTPError with 403" do
            WebMock.stub(:get, "https://api.github.com/user")
              .with(headers: {"Accept"     => "application/vnd.github.v3+json",
                              "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
              .to_return(status: 403)

            client = GithubCr::Client.new("octocat", "octocat_password")

            expect_raises(GithubCr::ForbiddenError) do
              client_user = client.user
            end
          end
        end

        it "raises a GithubCr::HTTPError with 401" do
          json_body = File.read("#{__DIR__}/mocked_json/mocked_401.json")

          WebMock.stub(:get, "https://api.github.com/user")
            .with(headers: {"Accept"     => "application/vnd.github.v3+json",
                            "User-Agent" => "github-cr/#{GithubCr::VERSION}"})
            .to_return(status: 401, body: json_body)

          client = GithubCr::Client.new("octocat", "octocat_password")

          expect_raises(GithubCr::NotAuthenticatedError) do
            client_user = client.user
          end
        end
      end

      context "when login is passed" do
        context "when user agent string is invalid" do
          it "raises GithubCr::HTTPError with 403" do
          end
        end

        it "raises a GithubCr::HTTPError with 401" do
        end
      end
    end
  end
end
