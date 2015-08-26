class CreateItemSetItems < ActiveRecord::Migration
  def change
    create_table :item_set_items do |t|
      t.belongs_to :item_set, index: true
      t.belongs_to :item_set_block, index: true
      t.belongs_to :item, index: true

      t.integer :item_set_id
      t.integer :item_set_block_id
      t.integer :item_id
      t.integer :count

      t.timestamps null: false
    end
  end
end
