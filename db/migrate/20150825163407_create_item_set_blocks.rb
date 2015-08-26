class CreateItemSetBlocks < ActiveRecord::Migration
  def change
    create_table :item_set_blocks do |t|
      t.belongs_to :item_set, index: true

      t.string  :type
      t.string  :hideIfSummonerSpell
      t.string  :showIfSummonerSpell
      t.boolean :recMath
      t.integer :minSummonerLevel
      t.integer :maxSummonerLevel

      t.timestamps null: false
    end
  end
end
