# == Schema Information
#
# Table name: item_set_items
#
#  id                :integer          not null, primary key
#  item_set_id       :integer
#  item_set_block_id :integer
#  item_id           :integer
#  count             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ItemSetItem < ActiveRecord::Base
  belongs_to :item_set
  belongs_to :item_set_block
  belongs_to :item
end
