require 'test_helper'

module Converter
  class XmlToItemTest < ActiveSupport::TestCase
    
    def test_property_values
      assert_equal 25, xml_to_item.property_values.length
      
      property_value = xml_to_item.property_values.select{|p| p[:datastream] == 'DC.1'}.first
      
      expected_name = property_value_in_xml_file.first
      assert_equal expected_name, property_value[:name]
      
      expected_value = property_value_in_xml_file.last
      assert_equal expected_value, property_value[:value]
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
        assert_equal multiple_type, property[:multiple_type], "property #{name} multiple_type should be #{multiple_type}"
      end
    end
    
    def test_object_properties
      expected = {
        'Active' => false,
        'ora:2141' => false,
        'fedoraAdmin' => false,
        '2008-06-27T10:32:18.792Z' => false,
        '2014-02-05T00:31:44.421Z' => false,
        'FedoraObject' => true
      }
      expected.each do |value, external|
        object_property = xml_to_item.object_properties.select{|p| p[:value] == value}.first
        assert_equal external, object_property[:external], 
          "external should be #{external} for #{object_property.inspect}"
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
