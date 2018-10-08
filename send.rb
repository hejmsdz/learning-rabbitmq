#!/usr/bin/env ruby
require 'bunny'

conn = Bunny.new
conn.start
begin
  ch = conn.create_channel
  q = ch.queue('test')

  ch.default_exchange.publish('no siema', routing_key: q.name)
  puts 'message sent!'
ensure
  conn.close
end
