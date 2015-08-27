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
  
  def uuid_of_item_in_xml_file
    'uuid:0d0a0b0d-0b1f-44c8-8ee0-752abb4bf8d0'
  end
  
  def property_value_in_xml_file
    ["title", "Public policy towards R&D in oligopolistic industries"]
  end
  
  def fedora_config_yml_path
    full_path_to('data/fedora_config.yml')
  end
  
  def fedora_config_yml
    YAML.load_file fedora_config_yml_path
  end
  
  def get_content_of(local_path)
    path = full_path_to(local_path)
    raise "#{local_path} missing - unable to get content of file" unless File.exist?(path)
    File.read path
  end
  
  def full_path_to(local_path)
    File.expand_path local_path, File.dirname(__FILE__)
  end
  
  def fedora_root
    'http://example.com/fedora'
  end

  def stub_url_root
    "http://#{username}:#{password}@example.com/fedora"
  end

  def username
    'Foo'
  end

  def password
    'password'
  end

  def item_data
    @item_data ||= item_xml_from_file
  end
  
  def stub_call_to_fedora_to_get_xml_for(item)
    stub_request(:get, "#{stub_url_root}/objects/#{item.identifier}/objectXML").
        to_return(:status => 200, :body => item_data)
  end
  
end
