# lib/advent_2019/day1.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "optparse"

# Base class used for enumerating daily solutions.  Heirs must implement a #run
# method that two arguments:
# * a hash of views over the input file
# * a kwargs containing any additional arguments parsed from the command-line
class Day
  # @return the days in this application
  def self.days
    days = ObjectSpace
      .each_object(Day.singleton_class)
      .find_all { |klass| klass < self }
    days
      .map { |day| [day::NAME, day.new] }
      .to_h
  end

  # Parses the command-line arguments for the day.  By default, it only supports
  # parsing out the input argument.  Heirs must respect this when parsing any
  # additional arguments.
  # @param [Array<String>] argv the command-line arguments to parse
  # @return [Hash{Symbol->String}] the command-line arguments and their values
  def parse!(argv)
    options = {}
    parser = OptionParser.new do |opt|
      opt.on("-iINPUT", "--input INPUT", "the input file") do |name|
        options[:filename] = name
      end
    end
    parser.parse!(argv)
    Advent2019.show_help(parser) unless options.has_key?(:filename)
    options
  end
end

# Ensure that heirs of Day are loaded, so that enumerating them actually returns
# a result.
module_path = File.dirname(__FILE__)
Dir.glob(module_path + "/day?*.rb") { |file| require file }