require 'dalli'

module Memcached
  @@dalli = Dalli::Client.new()
end