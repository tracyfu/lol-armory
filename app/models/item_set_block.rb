# == Schema Information
#
# Table name: item_set_blocks
#
#  id                     :integer          not null, primary key
#  item_set_id            :integer
#  block_type             :string(255)
#  hide_if_summoner_spell :string(255)
#  show_if_summoner_spell :string(255)
#  recMath                :boolean
#  min_summoner_level     :integer
#  max_summoner_level     :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class ItemSetBlock < ActiveRecord::Base
  has_many :item_set_items
  has_many :items, through: :item_set_items
  belongs_to :item_set
end
