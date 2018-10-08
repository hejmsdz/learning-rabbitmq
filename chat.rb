#!/usr/bin/env ruby
require 'bunny'

conn = Bunny.new
conn.start
begin
  ch = conn.create_channel
  q = ch.queue('test')

  puts 'waiting for messages...'

  q.subscribe(block: false) do |_delivery_info, _properties, body|
    puts "received: #{body}"
  end

  loop do
    msg = gets.chomp
    exit if msg.empty?
    ch.default_exchange.publish(msg, routing_key: q.name)
  end
ensure
  conn.close
end
