# == Schema Information
#
# Table name: item_sets
#
#  id          :integer          not null, primary key
#  champion_id :integer
#  priority    :boolean
#  sortrank    :integer
#  map         :string(255)
#  mode        :string(255)
#  title       :string(255)
#  set_type    :string(255)
#  created_by  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ItemSet < ActiveRecord::Base
  has_many :item_set_blocks, dependent: :destroy
  has_many :item_set_items, through: :item_set_blocks, dependent: :destroy
  belongs_to :champion
end
