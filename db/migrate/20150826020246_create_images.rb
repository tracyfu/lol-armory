class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true, index: true

      t.string  :full
      t.string  :sprite
      t.string  :group
      t.integer :x
      t.integer :y
      t.integer :w
      t.integer :h

      t.timestamps null: false
    end
  end
end
