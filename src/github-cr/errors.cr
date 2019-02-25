module GithubCr
  class HTTPError < Exception
    getter status_code

    def initialize(@status_code : Int32, message : String)
      super(message)
    end
  end
end
