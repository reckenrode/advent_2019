# lib/advent_2019/int_code.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/day1"

module IntCode
  OPCODES = [1, 2, 99]
  class VM
    attr_reader :memory, :pc

    def initialize(memory)
      @memory = memory
      @pc = 0
    end
  end
end