class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.boolean :consumed
      t.boolean :consume_on_full
      t.boolean :hide_from_all
      t.boolean :in_store
      t.integer :depth
      t.integer :special_recipe
      t.integer :stacks
      t.string  :colloq
      t.string  :from
      t.string  :group
      t.string  :into
      t.string  :name
      t.string  :required_champion
      t.text    :description
      t.text    :effect
      t.text    :plaintext
      t.text    :sanitized_description
      t.text    :stats
      t.text    :tags

      t.timestamps null: false
    end
  end
end
