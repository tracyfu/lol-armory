class HomeController < ApplicationController
  def index
    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    @champions = client.static.champion.get(champData: 'image')
  end

  def import
    require 'lol'

    client    = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    champions = client.static.champion.get(champData: 'all')
    items     = client.static.item.get(itemListData: 'all')

    items.each do |i|
      i    = i.to_h
      i    = Hash[i.map { |k, v| [k.to_s.underscore.to_sym, v] }]
      item = Item.new(i.except(:image, :gold))

      if item.save
        if i.key?(:image)
          i[:image][:imageable] = item

          image = Image.new(i[:image])
          image.save
        end

        if i.key?(:gold)
          i[:gold][:item] = item

          cost = Cost.new(i[:gold])
          cost.save
        end
      end
    end

    champions.each do |c|
      c = c.to_h
      champion = Champion.new(c.slice(:id, :key, :name, :title, :tags))

      if champion.save
        if c.key?(:image)
          c[:image][:imageable] = champion

          image = Image.new(c[:image])
          image.save
        end

        if c.key?(:recommended)
          recommended_set = (c[:recommended].select { |set| (set['map'] == 'SR' || set['map'] == '1') && set['mode'] == 'CLASSIC' }).first

          unless recommended_set.nil?
            recommended_set.symbolize_keys!
            recommended_set[:champion]   = champion
            recommended_set[:map]        = 'SR'
            recommended_set[:set_type]   = recommended_set.delete :type
            recommended_set[:created_by] = 'Riot'

            item_set = ItemSet.new(recommended_set.except :blocks)
            item_set.save

            recommended_set[:blocks].each do |block|
              block.symbolize_keys!
              block[:item_set]   = item_set
              block[:block_type] = block.delete :type

              item_set_block = ItemSetBlock.new(block.except :items)
              item_set_block.save

              block[:items].each do |item|
                item                  = Hash[item.map { |k, v| [k.to_s.underscore.to_sym, v] }]
                item[:item_set]       = item_set
                item[:item_set_block] = item_set_block
                item[:item]           = Item.find(item.delete :id)

                item = ItemSetItem.new(item)
                item.save
              end
            end
          end
        end
      end
    end

    render nothing: true
  end
end
