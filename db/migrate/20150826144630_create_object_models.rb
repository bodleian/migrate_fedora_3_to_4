class CreateObjectModels < ActiveRecord::Migration
  def change
    create_table :object_models do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
