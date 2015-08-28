class AddSourceUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :source_url, :text, limit: 1000
  end
end
