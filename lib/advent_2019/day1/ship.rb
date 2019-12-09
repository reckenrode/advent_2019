# lib/advent_2019/day1/ship.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

class Ship
  # Calculates the ship’s fuel requirements for the given modules.
  #
  # The amount of fuel needed is based on the individual masses of the modules.
  #
  # @param [Numeric, Array<Numeric>] modules an array of modules’ masses
  # @return [Integer] the amount of fuel required by the ship
  def self.fuel_requirements(modules)
    arr = modules.respond_to?(:reduce) ? modules : [modules]
    arr.reduce(0) { |total, mass| total + (mass / 3).floor - 2 }
  end
end
