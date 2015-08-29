namespace :items do
  desc 'Patch broken item descriptions'
  task fix_descriptions: :environment do
    # Fix Youmuu's Ghostblade (duplicate closing passive tags)
    item = Item.where('name = "Youmuu\'s Ghostblade"').first
    description = item.description.gsub(/<\/passive>(((?!<passive>).)*)<\/passive>/, '</passive>\1')
    item.update_attribute(:description, description)

    # Fix Ardent Censer (missing closing i tag)
    item = Item.where('name = "Ardent Censer"').first
    description = item.description + '</i>'
    item.update_attribute(:description, description)
  end
end
