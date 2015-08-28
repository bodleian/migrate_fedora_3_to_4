class PropertyValue < ActiveRecord::Base
  
  belongs_to :item
  
  scope :namespace, ->(name){ where(namespace: name) }
end
