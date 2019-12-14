# spec/day2_spec.rb
# Copyright © 2019 Randy Eckenrode
#
# This program is distributed under the terms of the MIT license.  You should
# have received a copy of this license with this program.  If you did not, you
# can find a copy of this license online at https://opensource.org/licenses/MIT.
#
# frozen_string_literal: true
# encoding: utf-8

require "advent_2019/int_code"

RSpec.shared_examples "IntCode execution" do |parameter|
  opcode = parameter[:opcode]
  it "advances the PC after an opcode is executed" do
    vm = IntCode::VM.new [opcode, 0, 0, 0]
    vm.step!
    expect(vm.registers.pc).to eq(4)
  end
end

RSpec.describe IntCode::VM do
  it "starts the PC at 0" do
    vm = IntCode::VM.new []
    expect(vm.registers.pc).to eq(0)
  end

  it "treats uninitialized memory as 0" do
    vm = IntCode::VM.new [1, nil, nil, nil]
    vm.step!
    expect(vm.memory[0]).to eq(2)
  end

  context "unknown opcodes" do
    opcode = IntCode::OPCODES.reduce(&:*)
    program = [opcode, 0, 0, 0]
    vm = nil

    before do
      vm = IntCode::VM.new(program.dup)
    end

    it "raises an error" do
      vm.step!
      expect(vm.registers.flags).to include(:decode_error)
    end

    it "halts execution" do
      vm.execute!
      expect(vm.registers.flags).to include(:stop)
    end
  end

  context "opcode 1" do
    include_examples "IntCode execution", opcode: 1

    it "adds position 1 to position 2 and writes it to position 3" do
      vm = IntCode::VM.new [1, 10, 20, 30]
      vm.step!
      expect(vm.memory[30]).to eq(0)
    end
  end

  context "opcode 2" do
    include_examples "IntCode execution", opcode: 2

    it "multiplies position 1 to position 2 and writes it to position 3" do
      vm = IntCode::VM.new [2, 1, 2, 15]
      vm.step!
      expect(vm.memory[15]).to eq(2)
    end
  end

  context "opcode 99" do
    it "does not advance the PC" do
      vm = IntCode::VM.new [99]
      vm.step!
      expect(vm.registers.pc).to eq(0)
    end

    it "ends execution" do
      vm = IntCode::VM.new [1, 2, 3, 50, 99]
      vm.execute!
      expect(vm.registers.flags).to include(:stop)
    end
  end

  context "sample programs" do
    [
      {
        number: 1,
        input: {program: [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]},
        expected: {memory: [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]},
      },
      {
        number: 2,
        input: {program: [1, 0, 0, 0, 99]},
        expected: {memory: [2, 0, 0, 0, 99]},
      },
      {
        number: 3,
        input: {program: [2, 3, 0, 3, 99]},
        expected: {memory: [2, 3, 0, 6, 99]},
      },
      {
        number: 4,
        input: {program: [2, 4, 4, 5, 99, 0]},
        expected: {memory: [2, 4, 4, 5, 99, 9801]},
      },
      {
        number: 5,
        input: {program: [1, 1, 1, 4, 99, 5, 6, 0, 99]},
        expected: {memory: [30, 1, 1, 4, 2, 5, 6, 0, 99]},
      },
    ].each do |test_case|
      it "##{test_case[:number]} executes correctly" do
        vm = IntCode::VM.new(test_case[:input][:program])
        vm.execute!
        expect(vm.memory).to eq(test_case[:expected][:memory])
      end
    end
  end
end