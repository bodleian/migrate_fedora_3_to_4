class AddExternalDatastreamsToItems < ActiveRecord::Migration
  def change
    add_column :items, :external_datastreams, :text
  end
end
