class AddNamespaceAndDatastreamToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :namespace, :string
    add_column :properties, :datastream, :string
  end
end
