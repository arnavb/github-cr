require "./src/github-cr"

print "Enter your Github username: "
user = gets.not_nil!

print "Enter your password: "
password = ""
STDIN.noecho do
  password = gets.not_nil!
end

client = GithubCr::Client.new(user, password)

begin
  client_user = client.user

  puts "Got user with name #{client_user.name}"
rescue ex : GithubCr::HTTPError
  puts "An error occurred! #{ex}"
end
