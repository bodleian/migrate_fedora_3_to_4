class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :multiple_type
      t.references :object_model, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
