class ObjectModel < ActiveRecord::Base
  
  UNKNOWN = 'unknown'
  
  has_many :items
  has_many :properties
  has_many :object_properties, through: :items
  
end
