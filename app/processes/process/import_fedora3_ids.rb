# Used to gather object ids from Fedora3 and insert them into object_ids

module Process
  module ImportFedora3Ids
    
    # Usage (on a dev system):
    # 
    #   Process::ImportFedora3Ids.run(
    #     base_url: 'http://localhost:8080/fedora3/risearch', 
    #     username: <username>, 
    #     password: <password>
    # 
    # Where <username> and <password> are the username and password for the local
    # instance of the Fedora3 database.
    #
    def self.run(args)
      connection = Connector::FedoraRisearch.new(args)
      data = connection.send_sparql sparql_to_get_ids
      Item.populate JSON.parse(data)
    end
    
    def self.sparql_to_get_ids
      'select $subject from <#ri> where { $subject <info:fedora/fedora-system:def/model#hasModel> $object}'
    end
    
  end
end
