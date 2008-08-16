#!/usr/bin/env ruby

require 'test/unit'

class Fixnum
  def fizzbuzz
    if fizz? && buzz?
      "fizzbuzz"
    elsif fizz?
      "fizz"
    elsif buzz?
      "buzz"
    else
      to_s
    end
  end

  def fizz?
    (self % 3) == 0
  end

  def buzz?
    (self % 5) == 0
  end

end

class FizzBuzzTest < Test::Unit::TestCase
  def test_non3_non5_numbers_are_normal
    assert_equal "1", 1.fizzbuzz
    assert_equal "2", 2.fizzbuzz
  end

  def test_divisible_by_3_is_fizz
    assert_equal "fizz", 3.fizzbuzz
    assert_equal "fizz", 33.fizzbuzz
  end

  def test_divisible_by_5_is_buzz
    assert_equal "buzz", 5.fizzbuzz
    assert_equal "buzz", 55.fizzbuzz
  end

  def test_divisible_by_both_is_fizzbuzz
    assert_equal "fizzbuzz", 0.fizzbuzz
    assert_equal "fizzbuzz", 15.fizzbuzz
    assert_equal "fizzbuzz", 300.fizzbuzz
  end

end
