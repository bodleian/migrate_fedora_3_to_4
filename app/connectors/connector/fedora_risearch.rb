# The FedoraRiscearch connector is used to gather data from the Fedora 3 instance,
# via the risearch interface. This is done by posting SPARQL queries to 
# 
#   <fedora_root>/risearch
#
# For example: http://localhost:8080/fedora3/risearch
#
module Connector
  class FedoraRisearch
    
    DEFAULT_OPTIONS = {
      type: 'tuples',
      lang: 'itql',
      format: 'json',
      limit: '',
      dt: 'on'
    }
    
    attr_accessor :base_url, :type, :lang, :format, :limit, :dt, :username, :password
    
    def initialize(args)
      args = DEFAULT_OPTIONS.merge args
      @base_url = args[:base_url]
          @type = args[:type]
          @lang = args[:lang]
        @format = args[:format]
         @limit = args[:limit]
            @dt = args[:dt]
      @username = args[:username]
      @password = args[:password]
    end
    
    def send_sparql(sparql)
      request.basic_auth username, password
      request.set_form_data(
        type: type,
        lang: lang,
        format: format,
        limit: limit,
        dt: dt,
        query: sparql     
      )
      response.body
    end
     
    def uri
      URI(base_url)
    end
    
    def request
      @request ||= Net::HTTP::Post.new(uri.path)
    end
    
    def response
      @response ||= Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    end
    
  end
end
