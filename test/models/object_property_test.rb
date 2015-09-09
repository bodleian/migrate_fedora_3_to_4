require 'test_helper'

class ObjectPropertyTest < ActiveSupport::TestCase
  
  def test_short_name
    short_name = 'this'
    object_property.name = "info:fedora/fedora-system:def/model##{short_name}"
    assert_equal short_name, object_property.short_name
  end
  
  def test_property_type
    assert_equal :property, object_property.property_type
  end
  
  def test_property_type_when_external
    assert_equal :extproperty, external_object_property.property_type
  end
  
  def object_property
    @object_property ||= object_properties :one
  end
  
  def external_object_property
    @external_object_property ||= object_properties :two
  end
  
end
