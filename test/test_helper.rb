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
  
  def build_id_list_json
    text = get_content_of 'data/id_list.json'
    JSON.parse text
  end
  
  def id_list_json_valid_id_count
    146
  end
  
  def sparql_to_get_id_list
    'select $subject from <#ri> where { $subject <info:fedora/fedora-system:def/model#hasModel> $object}'
  end
  
  def item_xml_from_file
    get_content_of 'data/item.xml'
  end
  
  def get_content_of(local_path)
    path = File.expand_path local_path, File.dirname(__FILE__)
    raise "#{local_path} missing - unable to get content of file" unless File.exist?(path)
    File.read path
  end
end
