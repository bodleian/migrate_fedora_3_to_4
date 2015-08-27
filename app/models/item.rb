# An object id is used to store object ids gathered from the fedora 3 instance
class Item < ActiveRecord::Base
  
  belongs_to :object_model
  
  def self.populate(hash)
    return unless hash['results']
    hash['results'].each do |result|
      text = result['subject']
      match = text.match uuid_pattern
      find_or_create_by(identifier: match[0]) if match
    end
  end
  
  def self.uuid_pattern
    prefix = 'uuid'
    separator = '\:'
    uuid_pattern = '[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}'
    Regexp.new (prefix + separator + uuid_pattern)
  end
  
end
