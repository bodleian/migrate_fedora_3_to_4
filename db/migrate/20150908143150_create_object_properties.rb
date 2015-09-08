class CreateObjectProperties < ActiveRecord::Migration
  def change
    create_table :object_properties do |t|
      t.references :object_model, index: true, foreign_key: true
      t.string :name
      t.string :value
      t.boolean :external, default: false

      t.timestamps null: false
    end
  end
end
