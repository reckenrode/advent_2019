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
    parser.on("--noun NOUN", "set the noun to NOUN", Integer)
    parser.on("--verb VERB", "set the verb to VERB", Integer)
    parser.on("--seek RESULT", "seek the result by varying the verb and noun",
      Integer)
    parser
  end

  def run(file, options)
    program = file.read.split(",").map(&:to_i)
    if target = options[:seek]
      starting_verb = options[:noun] || 0
      starting_noun = options[:verb] || 0
      noun, verb = Day2.seek_result(program, target, starting_verb,
        starting_noun, Day2.distance_from_target(program, target, starting_verb,
          starting_noun))
      puts "Noun: #{noun}, Verb: #{verb} => Output: #{target}"
    else
    puts "Output: #{Day2.run_program(program, options[:noun], options[:verb])}"
    end
  end

  private_class_method

  def self.distance_from_target(program, target, noun, verb)
    (target - Day2.run_program(program.dup, noun, verb)).abs
  end

  def self.seek_result(program, target, noun, verb, current_distance)
    return [noun, verb] if current_distance == 0
    possibilities = [
      [noun - 1, verb - 1],
      [noun - 1, verb],
      [noun - 1, verb + 1],
      [noun, verb - 1],
      [noun, verb + 1],
      [noun + 1, verb - 1],
      [noun + 1, verb],
      [noun + 1, verb + 1],
    ].filter { |n, v| n >= 0 && v >= 0 }
    possibilities
      .map! { |n, v| [n, v, distance_from_target(program, target, n, v)] }
      .filter! { |_, _, distance| distance < current_distance }
    candidate_noun, candidate_verb, distance = possibilities.sample
    seek_result(program, target, candidate_noun, candidate_verb, distance)
  end

  def self.run_program(program, noun, verb)
    vm = IntCode::VM.new(program)
    vm.memory[1] = noun
    vm.memory[2] = verb
    vm.execute!
    vm.memory[0]
  end
end