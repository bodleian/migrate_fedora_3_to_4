# An object id is used to store object ids gathered from the fedora 3 instance
class Item < ActiveRecord::Base
  
  belongs_to :object_model
  delegate :name, to: :object_model, prefix: true
  
  has_many :properties, through: :object_model
  has_many :property_values
  has_many :object_properties
  
  serialize :external_datastreams, Array
  
  paginates_per 25
  
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
  
  def to_param
    identifier
  end
  
end
