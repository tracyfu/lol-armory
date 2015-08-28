class CreateItemSetBlocks < ActiveRecord::Migration
  def change
    create_table :item_set_blocks do |t|
      t.belongs_to :item_set, index: true

      t.string  :block_type
      t.string  :hide_if_summoner_spell
      t.string  :show_if_summoner_spell
      t.boolean :rec_math
      t.integer :min_summoner_level
      t.integer :max_summoner_level

      t.timestamps null: false
    end
  end
end
