require 'test_helper'

class ObjectPropertyTest < ActiveSupport::TestCase
  
  def test_short_name
    short_name = 'this'
    object_property.name = "info:fedora/fedora-system:def/model##{short_name}"
    assert_equal short_name, object_property.short_name
  end
  
  def object_property
    @object_property ||= object_properties :one
  end
  
end
