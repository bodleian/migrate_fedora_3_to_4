class ChangeObjectIdsToItems < ActiveRecord::Migration
  def change
    rename_table 'object_ids', 'items'
  end
end
