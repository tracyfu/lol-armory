class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.references :recipe, index: true

      t.integer :id
      t.string :name
      t.string :group
      t.text :description
      t.text :sanitizedDescription
      t.text :plaintext

      t.timestamps null: false
    end
  end
end
