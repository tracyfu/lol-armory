# == Schema Information
#
# Table name: item_sets
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  type       :string(255)
#  map        :string(255)
#  mode       :string(255)
#  priority   :boolean
#  sortrank   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ItemSet < ActiveRecord::Base
  has_many :item_set_blocks
  has_many :items, through: :item_set_blocks
end
