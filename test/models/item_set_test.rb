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

require 'test_helper'

class ItemSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
