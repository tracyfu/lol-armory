class CreateItemSets < ActiveRecord::Migration
  def change
    create_table :item_sets do |t|
      t.belongs_to :champion, index: true

      t.boolean :priority
      t.integer :sortrank
      t.string  :map
      t.string  :mode
      t.string  :title
      t.string  :type

      t.timestamps null: false
    end
  end
end
