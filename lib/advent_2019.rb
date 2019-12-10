# lib/advent_2019.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/day"
require "advent_2019/version"

module Advent2019
  class Error < StandardError; end

  # Helper method to convert file into a hash containing various ways to view
  # the given file.
  # @param [File] file
  # @return a hash containing :raw access to or the :lines in the file
  def self.get_file_views(file)
    {
      raw: file,
      lines: file.each_line,
    }
  end

  # Runs the Advent of Code 2019 solution indicated by the first element of
  # argv.  The remaining elements of argv will be parsed as that day’s
  # command-line arguments.
  #
  # @param [Array<String>] argv the command-line arguments
  def self.main(argv)
    show_help if argv.count == 0
    Day.new
    day = Day.days[argv.shift]
    options = day.parse!(argv)
    File.open(options.delete(:filename), "r") do |file|
      readers = get_file_views(file)
      day.run(readers, **options)
    end
  end

  def self.show_help(msg = nil)
    if msg.nil?
      msg = OptionParser.new do |parser|
        parser.banner = "Usage: advent_2019 <day> [options]"
        parser.on("-h", "--help", "show this help message")
        parser.separator "\nAvailable Days: #{Day.days.keys.sort.join(", ")}"
      end
    end
    puts msg
    exit
  end
end