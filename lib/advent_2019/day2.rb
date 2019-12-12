# lib/advent_2019/day2.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/day"
require "advent_2019/int_code"

class Day2 < Day
  NAME = "day2"

  def configure!(parser)
    parser = super(parser)
    parser.on("--restore",
      "restore the system to the state prior to the 1202 program alarm",
      TrueClass)
    parser
  end

  def run(file, **kwargs)
    program = file.read.split(",").map(&:to_i)
    if kwargs[:restore]
      program[1] = 12
      program[2] = 2
    end
    vm = IntCode::VM.new(program)
    vm.execute!
    puts "Value at position 0: #{vm.memory[0]}"
  end
end