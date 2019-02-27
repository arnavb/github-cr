module GithubCr
  class HTTPError < Exception
    getter status_code

    def initialize(@status_code : Int32, message : String)
      super("#{status_code}: #{message}")
    end
  end
end
