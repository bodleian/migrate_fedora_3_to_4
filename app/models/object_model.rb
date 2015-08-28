class ObjectModel < ActiveRecord::Base
  
  UNKNOWN = 'unknown'
  
  has_many :items
  has_many :properties
  
end
