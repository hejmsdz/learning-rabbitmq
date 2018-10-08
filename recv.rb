#!/usr/bin/env ruby
require 'bunny'

conn = Bunny.new
conn.start
begin
  ch = conn.create_channel
  q = ch.queue('test')

  puts 'waiting for messages...'

  q.subscribe(block: true) do |_delivery_info, _properties, body|
    puts "received: #{body}"
  end
ensure
  conn.close
end
