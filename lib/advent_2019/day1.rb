# frozen_string_literal: true

# lib/advent_2019/day1.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.

require 'advent_2019/day'
require 'optparse'

module Advent2019
  # Day 1 solution
  class Day1 < Day
    NAME = 'day1'

    # Calculates the fuel required for the given modules.
    # @param [Enumerable<Numeric>, Numeric] modules fuel modules by weight
    # @param [Boolean] include_fuel whether to also calculate the fuel’s weight
    # @return [Integer] the amount of fuel required by the modules (and fuel)
    def self.fuel_requirements(modules, include_fuel = false)
      arr = modules.respond_to?(:reduce) ? modules : [modules]
      fuel = arr.reduce(0) do |total, mass|
        fuel = [0, (mass / 3).floor - 2].max
        if include_fuel && fuel.positive?
          additional_fuel = fuel_requirements(fuel, include_fuel)
          fuel += additional_fuel if additional_fuel.positive?
        end
        total + fuel
      end
      fuel
    end

    def configure!(parser)
      parser.on('--include-fuel', 'include fuel in the weight calculation',
                TrueClass)
    end

    # @param [Hash{Symbol=>Boolean}] options
    def run(file, options)
      modules = file.each_line.map(&:to_i)
      include_fuel = options[:"include-fuel"] || false
      weight = Day1.fuel_requirements(modules, include_fuel)
      puts "The fuel requirements for all the modules is #{weight}."
    end
  end
end