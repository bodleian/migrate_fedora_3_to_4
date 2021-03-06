require 'test_helper'

module Connector
  class FedoraRisearchTest < ActiveSupport::TestCase
    
    def test_send_sparql
      stub_request(:post, stub_url).
         with(:body => {query: sparql}.merge(options_for_stub)).
         to_return(:status => 200, :body => id_list_json.to_json)

      
      result = fedora_risearch.send_sparql sparql
      assert_equal id_list_json, JSON.parse(result)
    end
    
    def test_send_sparql_count
      options_for_stub[:format] = 'count'
      stub_request(:post, stub_url).
         with(:body => {query: sparql}.merge(options_for_stub)).
         to_return(:status => 200, :body => '150')

      fedora_risearch.format = 'count'
      result = fedora_risearch.send_sparql sparql
      assert_equal '150', result
    end
    
    def test_send_sparql_using_defaults
      @options = { username: 'foo', password: 'bar'}
      test_send_sparql
    end
    
    def fedora_risearch
      @fedora_risearch ||= FedoraRisearch.new({fedora_root: fedora_root}.merge(options))
    end
    
    def options
      @options ||= {
        username: 'foo',
        password: 'bar'
      }.merge(options_for_stub)
    end
    
    def options_for_stub
      @options_for_stub ||= FedoraRisearch::DEFAULT_OPTIONS
    end
    
    def fedora_root
      'http://example.com'
    end
    
    def stub_url
      "http://#{options[:username]}:#{options[:password]}@example.com/risearch"
    end
    
    def sparql
      sparql_to_get_id_list
    end
    
  end
end
