# frozen_string_literal: true

# lib/advent_2019/day2.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.

require 'advent_2019/day'
require 'advent_2019/int_code'

module Advent2019
  # Day 2 solution
  class Day2 < Day
    NAME = 'day2'

    def configure!(parser)
      parser.on('--noun NOUN', 'set the noun to NOUN', Integer)
      parser.on('--verb VERB', 'set the verb to VERB', Integer)
      parser.on('--seek RESULT', 'seek the result by varying the verb and noun',
                Integer)
    end

    # @param [Hash{Symbol=>Integer}] options
    def run(file, options)
      prog = file.read.split(',').map(&:to_i)
      target = options[:seek]
      if target
        noun, verb = Day2.seek_result(prog, target, options[:verb] || 0,
                                      options[:noun] || 0)
        puts "Noun: #{noun}, Verb: #{verb} => Output: #{target}"
      else
        puts "Output: #{Day2.run_program(prog, options[:noun], options[:verb])}"
      end
    end

    # Calculates the distance from `target` given the provided program, noun, and
    # verb.
    # @param [Array<Integer>] program the IntCode program
    # @param [Integer] target the desired output
    # @param [Integer] noun the noun for `program`
    # @param [Integer] verb the verb for `program`
    # @return [Integer] the distance from the output of `program` to the target`
    def self.distance_from_target(program, target, noun, verb)
      (target - Day2.run_program(program.dup, noun, verb)).abs
    end

    # Finds the noun and verb that result in the `target` output.  This method
    # uses stochastic hill-climbing technique.  Raises an exception when there is
    # no solution.
    # @param [Array<Integer>] program the IntCode program
    # @param [Integer] target the desired output
    # @param [Integer] noun the noun for `program`
    # @param [Integer] verb the verb for `program`
    # @param [Integer] current_distance the distance to the `target`
    # @return [Array<Integer>] the noun and verb resulting in `target`
    def self.seek_result(program, target, noun, verb,
                         current_distance = distance_from_target(program, target,
                                                                 noun, verb))
      return [noun, verb] if current_distance.zero?

      possibilities = enumerate_neighbors(noun, verb)
      possibilities
        .filter! { |n, v| n >= 0 && v >= 0 }
        .map! { |n, v| [n, v, distance_from_target(program, target, n, v)] }
        .filter! { |_, _, distance| distance < current_distance }
      candidate_noun, candidate_verb, distance = possibilities.sample
      seek_result(program, target, candidate_noun, candidate_verb, distance)
    end

    # @param [Integer] noun
    # @param [Integer] verb
    # @return [Array<Integer>] all possible neighbors for `noun` and `verb`
    def self.enumerate_neighbors(noun, verb)
      [
        [noun - 1, verb - 1],
        [noun - 1, verb],
        [noun - 1, verb + 1],
        [noun, verb - 1],
        [noun, verb + 1],
        [noun + 1, verb - 1],
        [noun + 1, verb],
        [noun + 1, verb + 1]
      ]
    end

    # Executes the IntCode program.
    # @param [Array<Integer>] program the IntCode program
    # @param [Integer] noun the noun for `program`
    # @param [Integer] verb the verb for `program`
    def self.run_program(program, noun, verb)
      vm = IntCode::VirtualMachine.new(program)
      vm.memory[1] = noun
      vm.memory[2] = verb
      vm.execute!
      vm.memory[0]
    end

    private_class_method :distance_from_target, :seek_result,
                         :enumerate_neighbors, :run_program
  end
end