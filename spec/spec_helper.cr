require "spec"
require "../src/*"

require "webmock"

Spec.before_each &->WebMock.reset

def get_json(file)
  File.read("#{__DIR__}/mocked_json/#{file}")
end
