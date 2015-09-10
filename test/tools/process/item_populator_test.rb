

module Process
  class ItemPopulatorTest < ActiveSupport::TestCase
    
    def setup
      stub_call_to_fedora_to_get_xml_for(item)
    end
    
    def test_for     
      assert_difference 'ObjectModel.count' do
        use_for_to_populate_item
      end    
      assert_match fedora_root, item.source_url
      assert_equal external_datastreams_in_xml_file, item.external_datastreams.sort
    end
    
    def test_for_creates_object_properties
      assert_difference 'ObjectProperty.count', object_properties_defined_in_xml do
        use_for_to_populate_item
      end
    end
    
    def test_for_creates_property_values
      assert_difference 'item.property_values.count', values_defined_in_xml do
        use_for_to_populate_item
      end
    end
    
    def test_for_creats_properties
      assert_difference 'Property.count', properties_defined_in_xml do
        use_for_to_populate_item
      end
    end

    
    def test_add_properties
      assert_difference 'Property.count', properties_defined_in_xml do
        item_populator.add_properties
      end
      property = item.object_model.properties.find_by name: 'title'
      assert property, "Property should have been added to item's object model"
      assert_equal false, property.multiple_type
    end
    
    def test_add_properties_twice_does_not_create_duplicates
      test_add_properties
      assert_no_difference 'Property.count' do
        item_populator.add_properties
      end
    end
    
    def test_add_object_poperties
      assert_difference 'ObjectProperty.count', object_properties_defined_in_xml do
        item_populator.add_object_properties
      end
      expected_names = %w[state label ownerId createdDate lastModifiedDate type]
      actual_names = item.object_properties.collect &:short_name
      assert_equal expected_names.sort, actual_names.sort
    end
    
    def test_external_object_property_added_via_add_object_poperties
      test_add_object_poperties
      object_property = item.object_properties.find_by value: 'FedoraObject'
      assert_equal 'type', object_property.short_name
      assert_equal true, object_property.external?
    end
    
    def test_assign_to_object_model
      assert_difference 'ObjectModel.count' do
        item_populator.assign_to_object_model
      end
      assert_equal 'article', item.object_model_name
    end
    
    def test_assign_to_object_model_when_is_member_of_is_nil
      Converter::XmlToItem.any_instance.stubs(:is_member_of).returns(nil)
      assert_difference 'ObjectModel.count' do
        item_populator.assign_to_object_model
      end
      assert_equal ObjectModel::UNKNOWN, item.object_model_name
    end
    
    def test_add_property_values
      assert_difference 'item.property_values.count', values_defined_in_xml do
        item_populator.add_property_values
      end
      name, value = property_value_in_xml_file
      property_value = item.property_values.find_by name: name, datastream: 'DC.1'
      assert_equal value, property_value.value
    end
    
    def test_add_external_datastreams
      item_populator.add_external_datastreams
      assert_equal external_datastreams_in_xml_file, item.external_datastreams.sort
    end
    
    def test_record_source_url
      item_populator.record_source_url
      assert_match fedora_root, item.source_url
    end
    
    def item
      @item ||= Item.create(identifier: uuid_of_item_in_xml_file)
    end
    
    def item_populator
      @item_populator ||= ItemPopulator.new(
                            item,
                            fedora_root: fedora_root,
                            username: username,
                            password: password
                          )
    end
    
    def values_defined_in_xml
      25
    end
    
    def properties_defined_in_xml
      12
    end
    
    def object_properties_defined_in_xml
      6
    end
    
    def use_for_to_populate_item
      ItemPopulator.for(
        item,
        fedora_root: fedora_root,
        username: username,
        password: password
      )
    end
    
  end
end
