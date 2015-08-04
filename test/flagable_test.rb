require 'test_helper'

class FlagableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Flagable
  end
end
