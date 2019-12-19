# frozen_string_literal: true

# lib/advent_2019/int_code.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.

require 'advent_2019/day1'

module IntCode
  OPCODES = [1, 2, 99].freeze

  # Represents the addressable memory of the IntCode virtual machine.
  # Uninitialized values default to 0.
  class Memory < Array
    def [](*args)
      if args.count == 1
        super || 0
      else
        super
      end
    end
  end

  Registers = Struct.new(:instruction_pointer, :flags)

  # Virtual machine for executing IntCode programs. This VM is very low level
  # and does not enforce setting nouns or verbs, nor does it make assumptions
  # about the meaning of certain values in memory (such as address 0 being
  # the output).
  class VirtualMachine
    attr_reader :memory, :registers

    def initialize(memory)
      @memory = Memory.new(memory)
      @registers = Registers.new(0, Set.new)
    end

    def execute!
      step! until @registers.flags.include? :stop
    end

    def step!
      opcode, parameters = decode
      OPCODE_IMPL[opcode].call(parameters, registers, memory)
    end

    private

    def decode
      memory[@registers.instruction_pointer, 4]
    end

    def self.call_symbol(symbol)
      proc = symbol.to_proc
      lambda do |operands, registers, memory|
        ip = registers.instruction_pointer
        memory[memory[ip + 3]] = proc.call(*operands)
        registers.flags.clear
        registers.instruction_pointer += 4
      end
    end

    def self.update_flags(*symbols)
      lambda do |_, registers, _|
        registers.flags = *symbols
      end
    end

    private_class_method :call_symbol, :update_flags

    DECODE_ERROR = update_flags(:decode_error, :stop)

    OPCODE_IMPL = Hash.new(DECODE_ERROR).update(
      1 => call_symbol(:+),
      2 => call_symbol(:*),
      99 => update_flags(:stop)
    )
  end
end
