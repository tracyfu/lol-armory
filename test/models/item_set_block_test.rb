# == Schema Information
#
# Table name: item_set_blocks
#
#  id                     :integer          not null, primary key
#  item_set_id            :integer
#  block_type             :string(255)
#  hide_if_summoner_spell :string(255)
#  show_if_summoner_spell :string(255)
#  rec_math               :boolean
#  min_summoner_level     :integer
#  max_summoner_level     :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class ItemSetBlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
