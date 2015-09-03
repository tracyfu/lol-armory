namespace :items do
  desc 'Patch missing data'
  task fix_data: :environment do
    require 'json'

    # Fix Face of the Mountain (missing active tag)
    item = Item.where('name = "Face of the Mountain"').first
    tags = JSON.parse(item[:tags]).push('Active')
    item.update_attribute(:tags, tags)
  end
end
