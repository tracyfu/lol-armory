class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.belongs_to :item, index: true

      t.integer :base
      t.integer :total
      t.integer :sell
      t.boolean :purchasable

      t.timestamps null: false
    end
  end
end
