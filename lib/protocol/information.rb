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
  INFORMATION_COMMON_PARAMS =
  {
    :account => '001',
    :manage => '002',
    :fax => '005',
    :_006 => '006',
    :provider => '007',
    :id => '010',
    :alias => '012',
    :alert => '013',
    :ordinal => '015',
    :first_name => '016',
    :last_name => '017',
    :email => '018',
    :age => '019',
    :sex => '020',
    :_021 => '021',
    :phone => '022',
    :status => '023',
    :city => '024',
    :state => '025',
    :country => '026',
    :forward => '027',
    :store => '028',
    :_029 => '029',
    :listed => '030',
    :address => '031',
    :extra => '032',
    :_041 => '041',
    :_051 => '051'
  }

  class AccountInformation < Message
    def params_lut
      INFORMATION_COMMON_PARAMS
    end
    
    def operation_code
      '41'
    end
  end
  
  class BuddyInformation < Message
    def params_lut
      INFORMATION_COMMON_PARAMS
    end
    
    def operation_code
      '31'
    end
  end
end
