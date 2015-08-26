class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.boolean :consumed
      t.boolean :consumeOnFull
      t.boolean :hideFromAll
      t.boolean :inStore
      t.integer :depth
      t.integer :id
      t.integer :specialRecipe
      t.integer :stacks
      t.string  :colloq
      t.string  :from
      t.string  :group
      t.string  :into
      t.string  :name
      t.string  :requiredChampion
      t.text    :description
      t.text    :effect
      t.text    :plaintext
      t.text    :sanitizedDescription
      t.text    :stats
      t.text    :tags

      t.timestamps null: false
    end
  end
end
