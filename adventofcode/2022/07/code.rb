# frozen_string_literal: true
# typed: true

require("sorbet-runtime")

extend T::Sig

sig { params(input: String).returns(Integer) }
def a(input)
  0
end

sig { params(input: String).returns(Integer) }
def b(input)
  0
end

input = File.read(File.join(__dir__, "input.txt"))
puts "part A: " + a(input).to_s + "\n"
puts "part B: " + b(input).to_s + "\n"
