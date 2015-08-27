# Connects to Fedora and retrieves the XML file that describes an item
# Typical usage:
#
#  connection = Connector::ItemXml.new(
#        fedora_root: 'http://localhost:8080/fedora',
#        username: 'username',
#        password: 'password'
#      )
#  xml = connection.get_xml_for 'uuid:2eade3a6-8b0e-4a20-913f-e212080cbd34
#  
module Connector
  class ItemXml < Base
      
    # An example item_identifier:
    #    uuid:2eade3a6-8b0e-4a20-913f-e212080cbd34
    def get_xml_for(item_identifier)
      @uri = uri_for(item_identifier)
      authenticate_request
      response.body
    end
    
    # An example url:
    #    http://localhost:8080/fedora/objects/uuid:2eade3a6-8b0e-4a20-913f-e212080cbd34/objectXML
    def uri_for(item_id)
      uri = File.join fedora_root, 'objects', item_id, 'objectXML'
      URI(uri)
    end    
    
  end
end
