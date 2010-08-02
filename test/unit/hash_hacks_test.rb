require File.dirname(__FILE__) + '/../test_helper'

class HashHacksTest < Test::Unit::TestCase
  def test_symbolize_keys
    input    = {'foo' => 'bla bla', 'bar' => 'la la la'}
    expected = {:foo  => 'bla bla', :bar  => 'la la la'}

    assert_equal expected, input.symbolize_keys
  end
end