require 'test_helper'

class ObjectModelTest < ActiveSupport::TestCase
  
  def test_object_property_usage
    use_object_model_without_object_properties
    assert_equal({}, object_model.object_property_usage)
  end
  
  def test_object_property_usage_when_object_properties_exist
    object_property_names = object_model.object_properties.pluck(:name)
    # hash with keys as object property names, and values of 1 
    expected = [
                 object_property_names, 
                 Array.new(object_property_names.length, 1)
               ].transpose.to_h
               
    assert_equal expected, object_model.object_property_usage
  end
  
  def test_object_property_values_with_no_matching_name
    assert_equal [], object_model.object_property_values_for('unknown')
  end
  
  def test_object_property_values
    assert_equal(
      [object_property.value], 
      object_model.object_property_values_for(object_property.name)
    )
  end
  
  def test_object_property_usage_report
    use_object_model_without_object_properties
    assert_equal({}, report)
  end
  
  def test_object_property_usage_report_when_only_single_instances_of_property
    assert_equal [object_property.value], report[object_property.name]
  end
  
  def test_object_property_usage_report_when_small_number_of_identical_properties
    3.times do 
      item.object_properties.create(
        name: object_property.name, 
        value: object_property.value
      )  
    end
    test_object_property_usage_report_when_only_single_instances_of_property
  end
  
  def test_object_property_usage_report_when_small_variance_in_properties
    other_value = 'other value'
    3.times do 
      item.object_properties.create(
        name: object_property.name, 
        value: other_value
      )  
    end
    expected = [object_property.value, other_value].sort
    assert_equal expected, report[object_property.name]
  end
  
  def test_object_property_usage_report_when_many_propertes_each_unique
    many = ObjectModel::MANY_THREASHOLD + 1
    many.times do |index|
      item.object_properties.create(
        name: object_property.name, 
        value: index
      )
    end
    assert_equal ObjectModel::UNIQUE, report[object_property.name]
  end
  
  def test_object_property_usage_report_when_many_propertes_but_not_unique
    many = ObjectModel::MANY_THREASHOLD + 1
    many.times do |index|
      item.object_properties.create(
        name: object_property.name, 
        value: index
      )
    end
    3.times do 
      item.object_properties.create(
        name: object_property.name, 
        value: object_property.value
      )  
    end
    assert_equal ObjectModel::MULTIPLE, report[object_property.name]
  end
  
  def object_model
    @object_model ||= object_models(:bar)
  end
  
  def use_object_model_without_object_properties
    @object_model = object_models(:foo)
  end
  
  def object_property
    @object_property ||= object_model.object_properties.first
  end
  
  def item
    @item ||= object_model.items.first
  end
  
  def report 
    object_model.object_property_usage_report
  end
  
end
