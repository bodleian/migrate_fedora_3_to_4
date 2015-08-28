# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Connector
  class ItemXmlTest < ActiveSupport::TestCase
    
    def test_get_xml_for
      stub_call_to_fedora_to_get_xml_for(item) 

      xml = connection.get_xml_for item.identifier
      assert_equal item_data_for(item), xml
    end
    
    def test_get_xml_for_another_item
      stub_call_to_fedora_to_get_xml_for(item) 
      stub_call_to_fedora_to_get_xml_for(other_item) 
      one = connection.get_xml_for item.identifier
      two = connection.get_xml_for other_item.identifier
      assert_not_equal one, two
    end
    
    def other_item
      @other_item ||= items :two
    end
    
    def item
      @item ||= items :one
    end
    
    def connection
      @connection ||= Connector::ItemXml.new(
        fedora_root: fedora_root,
        username: username,
        password: password
      )
    end
    
  end
end
