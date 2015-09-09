class ObjectProperty < ActiveRecord::Base
  belongs_to :item
  
  def short_name
    name.split('#').last if name?
  end
end
