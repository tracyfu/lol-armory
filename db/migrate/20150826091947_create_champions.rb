class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions, id: false do |t|
      t.integer :id
      t.string  :key
      t.string  :name
      t.string  :title
      t.text    :tags

      t.timestamps null: false
    end
  end
end
