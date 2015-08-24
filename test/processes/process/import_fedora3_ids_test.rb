require 'test_helper'

module Process
  class ImportFedora3IdsTest < ActiveSupport::TestCase
    
    def test_run
      stub_call_to_get_ids       
      ObjectId.delete_all
      
      assert_difference 'ObjectId.count', id_list_json_valid_id_count do
        ImportFedora3Ids.run(
          fedora_root: 'http://example.com',
          username: username,
          password: password
        )
      end
    end
    
    def username
      'Foo'
    end
      
    def password
      'password'
    end
    
    def stub_call_to_get_ids
      url = "http://#{username}:#{password}@example.com/risearch"
      options = Connector::FedoraRisearch::DEFAULT_OPTIONS
      stub_request(:post, url).
         with(:body => {query: sparql_to_get_id_list}.merge(options)).
         to_return(:status => 200, :body => id_list_json.to_json)
    end

  end
end
