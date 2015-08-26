class AddDetailsToItems < ActiveRecord::Migration
  def change
    add_column :items, :colloq, :string
    add_column :items, :consumed, :boolean
    add_column :items, :consumeOnFull, :boolean
    add_column :items, :depth, :integer
    add_column :items, :effect, :text
    add_column :items, :hideFromAll, :boolean
    add_column :items, :inStore, :boolean
    add_column :items, :requiredChampion, :string
    add_column :items, :specialRecipe, :integer
    add_column :items, :stacks, :integer
  end
end
