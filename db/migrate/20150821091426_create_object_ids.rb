class CreateObjectIds < ActiveRecord::Migration
  def change
    create_table :object_ids do |t|
      t.string :identifier
      t.timestamps null: false
    end
  end
end
