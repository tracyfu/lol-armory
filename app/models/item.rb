# == Schema Information
#
# Table name: items
#
#  consumed             :boolean
#  consumeOnFull        :boolean
#  hideFromAll          :boolean
#  inStore              :boolean
#  depth                :integer
#  id                   :integer
#  specialRecipe        :integer
#  stacks               :integer
#  colloq               :string(255)
#  from                 :string(255)
#  group                :string(255)
#  into                 :string(255)
#  name                 :string(255)
#  requiredChampion     :string(255)
#  description          :text(65535)
#  effect               :text(65535)
#  plaintext            :text(65535)
#  sanitizedDescription :text(65535)
#  stats                :text(65535)
#  tags                 :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Item < ActiveRecord::Base
  has_many :images, as: :imageable, dependent: :destroy
  has_one :cost
end
