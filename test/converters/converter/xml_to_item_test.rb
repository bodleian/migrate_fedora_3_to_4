require 'test_helper'

module Converter
  class XmlToItemTest < ActiveSupport::TestCase
    
    def test_property_values
      assert_equal 25, xml_to_item.property_values.length
      
      expected_name = property_value_in_xml_file.first
      assert_equal expected_name, xml_to_item.property_values.first[:name]
      
      expected_value = property_value_in_xml_file.last
      assert_equal expected_value, xml_to_item.property_values.first[:value]
    end
    
    def test_properties
      expected = {
        "title"=>false, 
        "creator"=>true, 
        "subject"=>true, 
        "description"=>true, 
        "date"=>false, 
        "type"=>true, 
        "format"=>false, 
        "identifier"=>true, 
        "language"=>false, 
        "relation"=>true        
      }
      expected.each do |name, multiple_type|
        property = xml_to_item.properties.select{|p| p[:name] == name and p[:datastream] == 'DC.1'}.first
        assert_equal multiple_type, property[:mulitple_type], "ppoperty #{name} multiple_type should be #{multiple_type}"
      end
    end
    
    def test_member_of
      assert_equal 'article', xml_to_item.is_member_of
    end
    
    def xml_to_item
      @xml_to_item ||= XmlToItem.new item_xml_from_file
    end
  end
end
