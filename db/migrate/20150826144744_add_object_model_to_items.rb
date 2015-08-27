class AddObjectModelToItems < ActiveRecord::Migration
  def change
    add_reference :items, :object_model, index: true, foreign_key: true
  end
end
