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
  class LoginRequest < Message
    def params_lut
      {
        :username => '005',
        :password => '002',
        :timezone => '004',
        :window_size => '003'
      }
    end
    
    def operation_code
      '01'
    end

    def default_params(params)
      params[:timezone] ||= 8
      params[:window_size] ||= 5 # 2..13
      params
    end
  end

  class LoginResponse < Message
    def operation_code
      '051'
    end
  end
end
