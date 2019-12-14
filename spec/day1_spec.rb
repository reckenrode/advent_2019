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

RSpec.describe Day1 do
  context "calculating fuel for a single module" do
    [
      {name: "should require 0 fuel", input: {mass: 1}, expected: {fuel: 0}},
      {name: "is evenly divisible", input: {mass: 12}, expected: {fuel: 2}},
      {name: "needs rounding", input: {mass: 14}, expected: {fuel: 2}},
      {name: "is large", input: {mass: 100756}, expected: {fuel: 33583}},
    ].each do |test_case|
      it "the mass #{test_case[:name]}" do
        fuel = Day1.fuel_requirements(test_case[:input][:mass])
        expect(fuel).to eq(test_case[:expected][:fuel])
      end
    end
  end

  context "calculating fuel including the mass of the fuel" do
    [
      {name: "no mass", input: {mass: 14}, expected: {fuel: 2}},
      {name: "more fuel", input: {mass: 1969}, expected: {fuel: 966}},
      {name: "lots more fuel", input: {mass: 100756}, expected: {fuel: 50346}},
    ].each do |test_case|
      it "the fuel requires #{test_case[:name]}" do
        fuel = Day1.fuel_requirements(test_case[:input][:mass], true)
        expect(fuel).to eq(test_case[:expected][:fuel])
      end
    end
  end

  context "calculating fuel for multiple modules" do
    it "doesn’t consider fuel mass" do
      fuel = Day1.fuel_requirements([9, 20])
      expect(fuel).to eq(5)
    end

    it "considers fuel mass" do
      fuel = Day1.fuel_requirements([9, 40], true)
      expect(fuel).to eq(13)
    end
  end
end