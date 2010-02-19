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

$: << File.expand_path(File.dirname(__FILE__))
require 'actionpool'
require 'socket'
require 'helper'
require 'protocol'

module Cheezmiz
  class Broker
    STX = "\x02"
    ETX = "\x03"
    MIN_THREADS = 5
    MAX_THREADS = 15
    def initialize(params = {})
      @sequence_number = 1
      @callbacks = Hash.new { |hash, key| hash[key] = [] }
      @pool = ActionPool::Pool.new(
        :min_threads => (params[:min_threads] || MIN_THREADS),
        :max_threads => (params[:max_threads] || MAX_THREADS)
      )
    end
    
    def register_callback(operation, options = {:threaded => true}, &proc)
      @callbacks[operation] << options.merge({ :callback => proc })
    end
    
    def callbacks
      @callbacks
    end
 
   def send(message, params = {})
      raw = encode({ :message => message }.merge(params))
      result = @socket.send(raw, 0)
      process_callbacks(@callbacks[:outgoing], message)
      return raw, result
    end
       
    def connect(params = {})
      @socket = params[:socket] || begin
        params[:host] ||= 'ctp-a.chikka.com'
        params[:port] ||= 6301
        TCPSocket.open(params[:host], params[:port])
      end
    end

    def start
      @pool.process do
        @socket.while_reading { |buffer| process_messages(buffer) }
      end
    end

  private

    def tokenize(stream)
      #TODO: handle incomplete messages
      stream.scan(/.*?|^CTPv1\.[123] Kamusta.*/)
    end

    def checksum(message)
      checksum = 0
      message.bytes.each do |b|
        checksum += b
        checksum &= 0xFF
      end
      checksum
    end
    
    def encode(options)
      raw = "#{STX}" + options[:message].prototype
      sequence_number = begin
        options[:response_to].respond_to?(:sequence_number) ?
        options[:response_to].sequence_number :
        options[:response_to]
      end || @sequence_number
      raw.sub! /NNN/, sequence_number.to_s.rjust(3, '0')
      @sequence_number += 2
      @sequence_number &= 0xFF
      raw + sprintf('%2X', checksum(raw)) + "#{ETX}"
    end
  
    def process_messages(buffer)
      tokenize(buffer).each do |raw|
        message = Message.parse(raw)
        process_callbacks(@callbacks[:incoming], message)
        process_callbacks(@callbacks, message)
      end
    end
    
    def process_callbacks(callbacks, message)
      (begin
        callbacks.respond_to?(:each_pair) ?
        callbacks[message.operation] :
        callbacks
      end).each do |callback|
        callback[:threaded] ?
        @pool.process { callback[:callback].call(message) } :
        callback[:callback].call(message)
      end
    end
  end
end
