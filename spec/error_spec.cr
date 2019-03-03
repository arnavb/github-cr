require "./spec_helper"
require "http/client/response"

describe GithubCr::HTTPError do
  describe "#error_message" do
    context "when response contains message" do
      it "returns the error message" do
        response = HTTP::Client::Response.new(404, "{\"message\": \"Some message\"}")

        exception = GithubCr::HTTPError.new(response)

        exception.error_message.should eq "Some message"
      end
    end

    context "when response doesn't contain message" do
      it "returns a default error message" do
        response = HTTP::Client::Response.new(404)

        exception = GithubCr::HTTPError.new(response)

        exception.error_message.should eq "An unknown HTTP error occurred!"
      end
    end
  end

  describe "#status_code" do
    it "returns the response's status code" do
      response = HTTP::Client::Response.new(404)

      exception = GithubCr::HTTPError.new(response)

      exception.status_code.should eq 404
    end
  end
end
