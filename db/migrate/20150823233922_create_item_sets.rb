class CreateItemSets < ActiveRecord::Migration
  def change
    create_table :item_sets do |t|
      t.string :title
      t.string :type
      t.string :map
      t.string :mode
      t.boolean :priority
      t.integer :sortrank

      t.timestamps null: false
    end
  end
end
