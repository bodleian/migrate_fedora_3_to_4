# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Connector
  class ItemXmlTest < ActiveSupport::TestCase
    
    def test_get_xml
      stub_call_to_fedora_to_get_xml_for(item)
      
      connection = Connector::ItemXml.new(
        fedora_root: fedora_root,
        username: username,
        password: password
      )
      xml = connection.get_xml_for item.identifier
      assert_equal item_data, xml
    end
    
    def item
      items :one
    end
    
  end
end
