# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Connector
  class ItemXmlTest < ActiveSupport::TestCase
    
    def test_get_xml
      stub_request(:get, "#{stub_url_root}/objects/#{object_id.identifier}/objectXML").
        to_return(:status => 200, :body => item_data)

      
      
      connection = Connector::ItemXml.new(
        fedora_root: fedora_root,
        username: username,
        password: password
      )
      xml = connection.get_xml_for object_id.identifier
      assert_equal item_data, xml
    end
    
    def object_id
      object_ids :one
    end
    
    def fedora_root
      'http://example.com'
    end
    
    def stub_url_root
      "http://#{username}:#{password}@example.com"
    end
    
    def username
      'Foo'
    end
      
    def password
      'password'
    end
    
    def item_data
      @item_data ||= build_item_xml
    end
    
  end
end
