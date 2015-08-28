class AddDatastreamToPropertyValues < ActiveRecord::Migration
  def change
    add_column :property_values, :datastream, :string
  end
end
