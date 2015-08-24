
module Connector
  class Base

    attr_accessor :fedora_root, :username, :password, :uri
    
    def initialize(args)
      @fedora_root = args[:fedora_root]
         @username = args[:username]
         @password = args[:password]
    end
    
   
    def request
      @request ||= Net::HTTP::Get.new(uri.path)
    end
    
    def response
      @response ||= Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    end
    
    def authenticate_request
      request.basic_auth username, password
    end
    
  end
end
