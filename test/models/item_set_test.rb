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

require 'test_helper'

class ItemSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
