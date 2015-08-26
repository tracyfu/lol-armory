class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.string  :key
      t.string  :name
      t.string  :title
      t.text    :tags

      t.timestamps null: false
    end
  end
end
