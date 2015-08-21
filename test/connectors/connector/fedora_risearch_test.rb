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
    
    def fedora_risearch
      @fedora_risearch ||= FedoraRisearch.new({base_url: base_url}.merge(options))
    end
    
    def options
      {
        username: 'foo',
        password: 'bar'
      }.merge(options_for_stub)
    end
    
    def options_for_stub
      @options_for_stub ||= {
        type: 'tuples',
        lang: 'itql',
        format: 'CSV',
        limit: '100',
        dt: 'on'
      }
    end
    
    def base_url
      'http://example.com/risearch'
    end
    
    def stub_url
      "http://#{options[:username]}:#{options[:password]}@example.com/risearch"
    end
    
    def sparql
      'select $subject from <#ri> where { $subject <info:fedora/fedora-system:def/model#hasModel> $object}'
    end
    
  end
end
