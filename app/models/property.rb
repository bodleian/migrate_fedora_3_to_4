class Property < ActiveRecord::Base
  belongs_to :object_model
  
  def multiple?
    multiple_type
  end
  
end
