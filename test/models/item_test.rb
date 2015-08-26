# == Schema Information
#
# Table name: items
#
#  id                    :integer          not null, primary key
#  consumed              :boolean
#  consume_on_full       :boolean
#  hide_from_all         :boolean
#  in_store              :boolean
#  depth                 :integer
#  special_recipe        :integer
#  stacks                :integer
#  colloq                :string(255)
#  from                  :string(255)
#  group                 :string(255)
#  into                  :string(255)
#  name                  :string(255)
#  required_champion     :string(255)
#  description           :text(65535)
#  effect                :text(65535)
#  plaintext             :text(65535)
#  sanitized_description :text(65535)
#  stats                 :text(65535)
#  tags                  :text(65535)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
