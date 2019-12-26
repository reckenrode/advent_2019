# frozen_string_literal: true

# lib/advent_2019/day1.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.

require 'optparse'

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
      .map { [_1::NAME, _1.new] }
      .to_h
  end

  # Parses the command-line arguments for the day.  By default, it only supports
  # parsing out the input argument.  Heirs must respect this when parsing any
  # additional arguments.
  # @param [Array<String>] argv the command-line arguments to parse
  # @return [Hash] the command-line arguments and their values
  def parse!(argv)
    options = {}
    parser = configure_base!(OptionParser.new)
    parser.parse!(argv, into: options)
    unless options.key?(:input)
      puts 'Missing --input argument, which is required.'
      Advent2019.show_help(parser)
    end
    options
  end

  # Executes the solution for the day.  By default, it does nothing.
  # @param [File] file the file containing the input for the day’s solution
  # @param [Hash] options any options passed to the solution
  def run(file, options); end

  protected

  # Sub-classes should override `configure!` to add options to the command-line
  # option parser.
  # @param [OptionParser] parser the parser to configure
  def configure!(parser); end

  private

  # Configures the base options common to all days.
  # @param [OptionParser] parser the parser to configure
  def configure_base!(parser)
    parser.banner = "Usage: advent_2019 #{self.class::NAME} [options]"
    parser.on('-i INPUT', '--input INPUT', 'the input file')
    parser.on_tail('-h', '--help', 'show this help message') do
      Advent2019.show_help(parser)
    end
    configure!(parser)
  end
end

# Ensure that heirs of Day are loaded, so that enumerating them actually works.
module_path = File.dirname(__FILE__)
Dir.glob("#{module_path}/day?*.rb").sort.each { require _1 }
