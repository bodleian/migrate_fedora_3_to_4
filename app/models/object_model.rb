class ObjectModel < ActiveRecord::Base
  
  has_many :items
  has_many :properties
  
end
