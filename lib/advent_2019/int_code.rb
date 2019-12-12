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

    def step!
      @memory[readmem(pc + 3)] = OPCODE_IMPL[readmem(pc)].call(
        readmem(readmem(pc + 1)),
        readmem(readmem(pc + 2))
      )
      @pc += 4
    end

    private

    OPCODE_IMPL = {
      1 => :+.to_proc,
      2 => :*.to_proc,
    }

    def readmem(address)
      memory[address] || 0
    end
  end
end