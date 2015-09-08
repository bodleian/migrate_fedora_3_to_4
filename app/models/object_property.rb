class ObjectProperty < ActiveRecord::Base
  belongs_to :object_model
  
  def short_name
    name.split('#').last if name?
  end
end
