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

  class Memory < Array
    def [](*args)
      if args.count == 1
        super || 0
      else
        super
      end
    end
  end

  Registers = Struct.new(:pc, :flag)

  class VM
    attr_reader :memory, :registers

    def initialize(memory)
      @memory = Memory.new(memory)
      @registers = Registers.new(0, nil)
    end

    def execute!
      step! while @registers.flag != :stop
    end

    def step!
      opcode, operands = decode
      OPCODE_IMPL[opcode].call(operands, registers, memory)
    end

    private

    def self.call_symbol(symbol)
      proc = symbol.to_proc
      lambda do |operands, registers, memory|
        pc = registers.pc
        memory[memory[pc + 3]] = proc.call(
          memory[memory[pc + 1]],
          memory[memory[pc + 2]]
        )
        registers.flag = nil
        registers.pc += 4
      end
    end

    def self.set_flag(symbol)
      lambda do |_, registers, _|
        registers.flag = symbol
      end
    end

    def decode
      memory[@registers.pc, 4]
    end

    DECODE_ERROR = set_flag(:decode_error)

    OPCODE_IMPL = Hash.new(set_flag(:decode_error)).update({
      1 => call_symbol(:+),
      2 => call_symbol(:*),
      99 => set_flag(:stop),
    })
  end
end