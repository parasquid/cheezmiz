#    cheezmiz - a ruby library for Chikka
#    Copyright (C) 2010  parasquid
#
#    This file is part of cheezmiz
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'cheezmiz'

if __FILE__ == $0
  CHIKKA_USERNAME = 'user@email.com'
  CHIKKA_PASSWORD = 'password'
  TEST_MESSAGE = 'a test message'

  socket = TCPSocket.open('ctp-a.chikka.com', 6301)
  broker = Cheezmiz::Broker.new :socket => socket
  broker.register_callback(:connection_established) do |msg|
    puts 'connection has been established'
    message = Cheezmiz::LoginRequest.new(
      :username => "#{CHIKKA_USERNAME}",
      :password => "#{CHIKKA_PASSWORD}"
    )
    broker.send(message)
  end

  broker.register_callback(:login_response) {
    puts 'login successful'
  }

  broker.register_callback(:account_information) do
    puts 'received account information'
    puts 'sending buddy list request'
    broker.send(Cheezmiz::BuddyListRequest.new)
  end

  broker.register_callback(:buddy_information) do
    puts 'received buddy information'
  end

  broker.register_callback(:buddy_list_end) do
    broker.send(Cheezmiz::ClientReady.new)
  end

  broker.register_callback(:keep_alive_request) do |msg|
    broker.send(Cheezmiz::KeepAliveResponse.new, :response_to => msg)
    puts 'sending test message'
    message = Cheezmiz::SubmitRequest.new(
      :message => "#{TEST_MESSAGE}",
      :buddy_number => 0
    )
    broker.send(message)
  end

  broker.register_callback(:submit_response) do
    puts 'server has acknowledged submit request'
  end

  broker.register_callback(:incoming) do |msg|
    if msg.operation == :unknown_operation
      puts "unknown operation: #{msg.prototype}"
    else
      puts "incoming message #{msg.operation} #{msg.data_fields.inspect}"
    end
  end

  broker.register_callback(:outgoing) do |msg|
    puts "outgoing message: #{msg.operation} #{msg.data_fields.inspect}"
  end
  
  broker.start
  broker.join
end
