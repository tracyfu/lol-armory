# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_id   :integer
#  imageable_type :string(255)
#  full           :string(255)
#  sprite         :string(255)
#  group          :string(255)
#  x              :integer
#  y              :integer
#  w              :integer
#  h              :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end
