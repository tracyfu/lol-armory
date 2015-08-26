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

require 'test_helper'

class ChampionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
