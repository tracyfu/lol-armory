# == Schema Information
#
# Table name: costs
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  base        :integer
#  total       :integer
#  sell        :integer
#  purchasable :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cost < ActiveRecord::Base
  belongs_to :item
end
