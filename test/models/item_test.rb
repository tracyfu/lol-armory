# == Schema Information
#
# Table name: items
#
#  recipe_id            :integer
#  id                   :integer
#  name                 :string(255)
#  group                :string(255)
#  description          :text(65535)
#  sanitizedDescription :text(65535)
#  plaintext            :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  tags                 :text(65535)
#  stats                :text(65535)
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
