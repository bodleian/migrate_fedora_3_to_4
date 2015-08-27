

module Process
  class ItemPopulatorTest < ActiveSupport::TestCase
    
    def setup
      stub_call_to_fedora_to_get_xml_for(item)
    end
    
    def test_do_for
      assert_difference 'ObjectModel.count' do
        assert_difference 'item.property_values.count', values_defined_in_xml do
          assert_difference 'Property.count', properties_defined_in_xml do
            ItemPopulator.do_for(
              item,
              fedora_root: fedora_root,
              username: username,
              password: password
            )
          end
        end
      end
    end
    
    def test_add_properties
      assert_difference 'Property.count', properties_defined_in_xml do
        item_populator.add_properties
      end
      property = item.object_model.properties.find_by name: 'title'
      assert property, "Property should have been added to item's object model"
    end
    
    def test_assign_to_object_model
      assert_difference 'ObjectModel.count' do
        item_populator.assign_to_object_model
      end
      assert_equal 'article', item.object_model_name
    end
    
    def test_assign_property_values
      assert_difference 'item.property_values.count', values_defined_in_xml do
        item_populator.assign_property_values
      end
      name, value = property_value_in_xml_file
      property_value = item.property_values.find_by name: name
      assert_equal value, property_value.value
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
      23
    end
    
    def properties_defined_in_xml
      10
    end
    
  end
end
