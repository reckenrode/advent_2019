# lib/advent_2019/day1.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/day"
require "advent_2019/day1/ship"
require "optparse"

class Day1 < Day
  NAME = "day1"

  def run(readers, **_)
  def configure!(parser)
    options = super(parser)
    parser.on("--[no-]fuel", "include fuel in the weight calculation") do |b|
      options[:include_fuel] = b
    end
    options
  end

    modules = readers[:lines].map(&:to_i)
    weight = Ship.fuel_requirements(modules)
    puts "The fuel requirements for all the modules is #{weight}."
  end
end