# Abstract class, used to define methods common to a number of connectors.
module Connector
  class Base
    
    attr_accessor :fedora_root, :username, :password, :uri
    
    def initialize(args)
      @fedora_root = args[:fedora_root]
         @username = args[:username]
         @password = args[:password]
    end
    
    def response
      Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    end
    
    def authenticate_request
      request.basic_auth username, password
    end
    
    def reset_request
      @request = nil
    end
    
  end
end
