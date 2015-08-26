# == Schema Information
#
# Table name: item_set_blocks
#
#  id                  :integer          not null, primary key
#  item_set_id         :integer
#  block_type          :string(255)
#  hideIfSummonerSpell :string(255)
#  showIfSummonerSpell :string(255)
#  recMath             :boolean
#  minSummonerLevel    :integer
#  maxSummonerLevel    :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ItemSetBlock < ActiveRecord::Base
  has_many :item_set_items
  has_many :items, through: :item_set_items
  belongs_to :item_set
end
