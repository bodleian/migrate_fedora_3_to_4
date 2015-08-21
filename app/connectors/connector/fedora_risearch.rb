

module Connector
  class FedoraRisearch
    attr_accessor :base_url, :type, :lang, :format, :limit, :dt, :username, :password
    
    def initialize(args)
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
      response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
      response.body
    end
    
    def uri
      URI(base_url)
    end
    
    def request
      @request ||= Net::HTTP::Post.new(uri.path)
    end
    
  end
end
