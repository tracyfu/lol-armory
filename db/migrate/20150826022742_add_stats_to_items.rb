class AddStatsToItems < ActiveRecord::Migration
  def change
    add_column :items, :stats, :text
  end
end
