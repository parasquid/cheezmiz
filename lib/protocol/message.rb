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

$: << File.expand_path(File.dirname(__FILE__) + "/../")
require 'protocol'
require 'helper'

module Cheezmiz
  class Message
    def initialize(params = nil)
      if params.respond_to?(:each_pair)
        @params = params
      else
        @params, @sequence_number = decode(params)
        @prototype = params
      end
      check_params @params if self.respond_to? :check_params
      @options = populate_from(@params)
    end

    def self.parse(stream)
      message = case stream
        when /^CTPv1\.[123] Kamusta/ then ConnectionEstablished.new stream
        when /^30:/ then BuddyListBegin.new stream
        when /^31:/ then BuddyInformation.new stream
        when /^39:/ then BuddyListEnd.new stream
        when /^40:/ then KeepAliveRequest.new stream
        when /^41:/ then AccountInformation.new stream
        when /^51:/ then LoginResponse.new stream
        when /^55:/ then SystemMessage.new stream
        when /^64:/ then SubmitResponse.new stream
        else                 UnknownOperation.new stream
        end
      message
    end

    def sequence_number
      @sequence_number
    end

    def data_fields
      @params
    end

    def operation
      self.class.simple_name.underscore.to_sym
    end
    
    def prototype
      @prototype || "#{header}#{data}"
    end
    
  private

    def data
      data = ''
      @options.each do |key, value|
        data << "#{key}:#{value}\t"
      end
      data
    end

    def header
      "#{operation_code}:NNN\t"
    end
    
    def decode(message)
      params = {}
      if message && self.respond_to?(:params_lut) && params_lut
        message[8..-5].split(/\t/).each do |field|
          field_key, field_data = field.split(/:/)
          if params_lut.invert[field_key]
            params[params_lut.invert[field_key]] = field_data
          end
        end
        sequence = message[0..7].split(/:/)[1]
      end
      return params, sequence
    end

   def populate_from(params)
      params.merge default_params(params) if self.respond_to? :default_params
      options = {}
      if self.respond_to? :params_lut
        params.each do |key, value|
          raise "Unknown parameter: #{key}" if !params_lut[key]
          options[params_lut[key]] = value
        end
      end
      options
    end
  end
end
