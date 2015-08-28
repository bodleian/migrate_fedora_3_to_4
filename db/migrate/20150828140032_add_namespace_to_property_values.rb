class AddNamespaceToPropertyValues < ActiveRecord::Migration
  def change
    add_column :property_values, :namespace, :string
  end
end
