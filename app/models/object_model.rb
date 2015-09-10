class ObjectModel < ActiveRecord::Base
  
  UNKNOWN = 'unknown'
  MANY_THREASHOLD = 10
  MULTIPLE = 'multiple'
  UNIQUE = 'unique'
  
  has_many :items
  has_many :properties
  has_many :object_properties, through: :items
  
  def object_property_usage
    object_properties.group(:name).count
  end
  
  def object_property_values_for(name)
    object_properties.where(name: name).pluck(:value)
  end
  
  # A hash with object property names as keys and values as the values
  # used by for those names. 
  # If there are many values (see MANY_THREASHOLD) then two options
  # will be returned:
  # 
  #   MULTIPLE: there are many difference values used for this object property
  #   UNIQUE:   each object_property of this type has a unique value
  #
  def object_property_usage_report
    object_property_usage.inject({}) do |hash, key_value|
      name, count = key_value
      values = object_property_values_for(name).uniq.sort
      hash[name] = if values.length > MANY_THREASHOLD
        values.length == count ? UNIQUE : MULTIPLE
      else
        values
      end
      hash
    end
  end
  
end
