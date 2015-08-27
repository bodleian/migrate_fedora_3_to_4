class CreatePropertyValues < ActiveRecord::Migration
  def change
    create_table :property_values do |t|
      t.string :name
      t.text :value
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
