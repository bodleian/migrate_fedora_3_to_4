
module Connector
  class ItemXml
    
    attr_accessor :fedora_root, :username, :password, :uri
    
    def initialize(args)
      @fedora_root = args[:fedora_root]
      @username = args[:username]
      @password = args[:password]
    end
    
    def get_xml_for(item_id)
      @uri = uri_for(item_id)
      request.basic_auth username, password
      response.body
    end
    
    def uri_for(item_id)
      uri = File.join fedora_root, 'objects', item_id, 'objectXML'
      URI(uri)
    end
    
    def request
      @request ||= Net::HTTP::Get.new(uri.path)
    end
    
    def response
      @response ||= Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    end
    
    
  end
end
