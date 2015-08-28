# == Schema Information
#
# Table name: champions
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  name       :string(255)
#  title      :string(255)
#  tags       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Champion < ActiveRecord::Base
  has_many :images, as: :imageable, dependent: :destroy
  has_many :item_sets

  def recommended_item_set
    item_sets.includes(item_set_blocks: [:item_set_items, items: [:images, :cost]]).where("item_sets.created_by = 'riot' and item_sets.map = 'SR'").first
  end
end
