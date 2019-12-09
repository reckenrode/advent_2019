# spec/day1_spec.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/day1"

RSpec.describe Ship do
  context "calculating fuel requirements" do
    [
      {name: "is evenly divisible", input: {mass: 12}, expected: {quantity: 2}},
      {name: "needs rounding", input: {mass: 14}, expected: {quantity: 2}},
      {name: "is large", input: {mass: 100756}, expected: {quantity: 33583}},
    ].each do |test_case|
      it "the mass #{test_case[:name]}" do
        fuel = Ship.fuel_requirements(test_case[:input][:mass])
        expect(fuel).to eq(test_case[:expected][:quantity])
      end
    end

    it "has multiple modules" do
      fuel = Ship.fuel_requirements([9, 20])
      expect(fuel).to eq(5)
    end
  end
end