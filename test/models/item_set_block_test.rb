# == Schema Information
#
# Table name: item_set_blocks
#
#  id                  :integer          not null, primary key
#  item_set_id         :integer
#  item_id             :integer
#  type                :string(255)
#  recMath             :boolean
#  minSummonerLevel    :integer
#  maxSummonerLevel    :integer
#  showIfSummonerSpell :string(255)
#  hideIfSummonerSpell :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class ItemSetBlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
