require "spec"
require "../src/*"

require "webmock"

Spec.before_each &->WebMock.reset
