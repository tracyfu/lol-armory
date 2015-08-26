class AddTagsToItems < ActiveRecord::Migration
  def change
    add_column :items, :tags, :text
  end
end
