require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  
  def test_multiple
    property = properties(:one)
    assert_equal false, property.multiple?
  end
  
  def test_multiple_when_true
    property = properties(:two)
    assert_equal true, property.multiple?
  end
  
end
