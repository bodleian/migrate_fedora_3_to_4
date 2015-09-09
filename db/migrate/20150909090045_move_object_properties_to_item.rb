class MoveObjectPropertiesToItem < ActiveRecord::Migration
  def up
    remove_reference :object_properties, :object_model, index: true, foreign_key: true
    add_reference :object_properties, :item, index: true, foreign_key: true
  end
  
  def down
    remove_reference :object_properties, :item, index: true, foreign_key: true
    add_reference :object_properties, :object_model, index: true, foreign_key: true
  end
end
