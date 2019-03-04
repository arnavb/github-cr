require "./src/github-cr"

password = ""

print "Pass: "
STDIN.noecho do
  password = gets.not_nil!.chomp
end
print ""

client = GithubCr::Client.new("test-github-cr", password)

repo = client.repo("arnavb/github-cr")

p repo.raw_json
