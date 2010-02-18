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
require 'message'

module Cheezmiz
  class SubmitRequest < Message
    def params_lut
      {
        :message => '032',
        :buddy_number => '021', # buddy list number
        :origin => '023', # optional
        :time_stamp => '022', # optional
        :type => '030',
        :msisdn => '001'
      }
    end
    
    def operation_code
      '14'
    end

   def default_params(params)
      params[:type] ||= 1 # pc or mobile?
      params
    end

    def check_params(params)
      if params.has_key?(:msisdn) && params.has_key?(:buddy_number)
        raise 'msisdn and buddy_number cannot be both present'
      end
    end
  end

  class SubmitResponse < Message
    def operation_code
      '64'
    end
  end
end
