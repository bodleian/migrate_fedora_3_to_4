require 'test_helper'

module Converter
  class XmlToItemTest < ActiveSupport::TestCase
    
    def test_property_values
      assert_equal 23, xml_to_item.property_values.length
      
      expected_name = property_value_in_xml_file.first
      assert_equal expected_name, xml_to_item.property_values.first[:name]
      
      expected_value = property_value_in_xml_file.last
      assert_equal expected_value, xml_to_item.property_values.first[:value]
    end
    
    def test_properties
      expected = {
        "title"=>"single", 
        "creator"=>"multi", 
        "subject"=>"multi", 
        "description"=>"multi", 
        "date"=>"single", 
        "type"=>"multi", 
        "format"=>"single", 
        "identifier"=>"multi", 
        "language"=>"single", 
        "relation"=>"multi"        
      }
      assert_equal expected, xml_to_item.properties
    end
    
    def test_member_of
      assert_equal 'article', xml_to_item.is_member_of
    end
    
    def xml_to_item
      @xml_to_item ||= XmlToItem.new item_xml_from_file
    end
  end
end
