ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def id_list_json
    @id_list_json ||= build_id_list_json
  end
  
  # data/dev_site_list.json contains json constructed by querying
  #  
  #   POST <fedora_root>/risearch
  #   
  # Where fedora_root is http://localhost:8080/fedora3 on this VM. 
  # So post to http://localhost:8080/fedora3/risearch
  #
  # With the query:
  #
  #  type:tuples
  #  lang:itql
  #  format:CSV
  #  limit:
  #  dt:on
  #  query:select $subject from <#ri> where { $subject <info:fedora/fedora-system:def/model#hasModel> $object}
  #
  def build_id_list_json
    local_path = 'data/dev_site_list.json'
    path = File.expand_path local_path, File.dirname(__FILE__)
    raise "#{local_path} missing - unable to build id_list json" unless File.exist?(path)
    text = File.read path
    JSON.parse text
  end
end
