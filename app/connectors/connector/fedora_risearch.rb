# The FedoraRiscearch connector is used to gather data from the Fedora 3 instance,
# via the risearch interface. This is done by posting SPARQL queries to 
# 
#   <fedora_root>/risearch
#
# For example: http://localhost:8080/fedora3/risearch
#
module Connector
  class FedoraRisearch < Base
    
    DEFAULT_OPTIONS = {
      type: 'tuples',
      lang: 'itql',
      format: 'json',
      limit: '',
      dt: 'on'
    }
    
    attr_accessor :type, :lang, :format, :limit, :dt
    
    # url should be the risearch url: <fedora_url>/risearch
    # username and password should be those of a user for the Fedora 
    # instance hosting risearch.
    def initialize(args)
      args = DEFAULT_OPTIONS.merge args

        @type = args[:type]
        @lang = args[:lang]
      @format = args[:format]
       @limit = args[:limit]
          @dt = args[:dt]
          
      super
    end
    
    # TODO catch failures to connect
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
      URI(File.join(fedora_root, 'risearch'))
    end
    
    def request
      @request ||= Net::HTTP::Post.new(uri.path)
    end
    

  end
end
