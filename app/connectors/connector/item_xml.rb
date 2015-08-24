
module Connector
  class ItemXml < Base
      
    def get_xml_for(item_id)
      @uri = uri_for(item_id)
      authenticate_request
      response.body
    end
    
    def uri_for(item_id)
      uri = File.join fedora_root, 'objects', item_id, 'objectXML'
      URI(uri)
    end    
    
  end
end
