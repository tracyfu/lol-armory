class HomeController < ApplicationController
  def index
    @default_champion = @champions[rand(@champions.length)]
  end

  # TODO: Move to Rake
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

        # Champion Recommended Items Documentation: https://developer.riotgames.com/api/methods#!/968/3326
        # Item Set Documentation: https://developer.riotgames.com/docs/item-sets
        if c.key?(:recommended)
          recommended_set = (c[:recommended].select { |set| (set['map'] == 'SR' || set['map'] == '1') && set['mode'] == 'CLASSIC' }).first

          unless recommended_set.nil?
            recommended_set.symbolize_keys!
            recommended_set[:champion]   = champion
            recommended_set[:map]        = 'SR'
            recommended_set[:set_type]   = recommended_set.delete :type
            recommended_set[:priority]   = recommended_set[:priority] || false
            recommended_set[:created_by] = 'Riot'

            item_set = ItemSet.new(recommended_set.except :blocks)
            item_set.save

            recommended_set[:blocks].each do |block|
              block.symbolize_keys!
              block[:item_set]           = item_set
              block[:block_type]         = (block.delete :type).gsub('jungle', ' jungle').humanize.titleize
              block[:rec_math]           = (block.delete :recMath) || false
              block[:min_summoner_level] = -1
              block[:max_summoner_level] = -1

              item_set_block = ItemSetBlock.new(block.except :items)
              item_set_block.save

              block[:items].each do |item|
                item                  = Hash[item.map { |k, v| [k.to_s.underscore.to_sym, v] }]
                item[:item_set]       = item_set
                item[:item_set_block] = item_set_block
                item[:item]           = Item.find(item.delete :id)

                item_set_item = ItemSetItem.new(item)
                item_set_item.save
              end
            end
          end
        end
      end
    end

    # Nidalee is the only champ without recommended items for Summoner's Rift - Classic Mode
    # Builds a recommended item set from in-game data
    nidalee = Champion.find_by(id: 76)

    unless nidalee.nil?
      recommended_set = {
        champion:   nidalee,
        map:        'SR',
        mode:       'CLASSIC',
        set_type:   'riot',
        created_by: 'Riot',
        title:      'NidaleeSR'
      }

      item_set = ItemSet.new(recommended_set)
      item_set.save

      items = [
        [1056, 2003, 3340],            # Starting:    [1056: Doran's Ring, 2003: Health Potion, 3340: Warding Totem (Trinket)]
        [3020, 3165, 3089],            # Essential:   [3020: Sorcerer's Shoes, 3165: Morellonomicon, 3089: Rabadon's Deathcap]
        [3135, 3100, 3285],            # Offensive:   [3135: Void Staff, 3100: Lich Bane, 3285: Luden's Echo]
        [3025, 3174, 3157],            # Defensive:   [3025: Iceborn Guantlet, 3174: Athene's Unholy Grail, 3157: Zhonya's Hourglass]
        [2003, 2004, 2044, 2043, 2139] # Consumables: [2003: Health Potion, 2004: Mana Potion, 2044: Stealth Ward, 2043: Vision Ward, 2139: Elixir of Sorcery]
      ]

      ['Starting', 'Essential', 'Offensive', 'Defensive', 'Consumables'].each_with_index do |block, index|
        block = {
          item_set:           item_set,
          block_type:         block,
          rec_math:           false,
          min_summoner_level: -1,
          max_summoner_level: -1
        }

        item_set_block = ItemSetBlock.new(block)
        item_set_block.save

        items[index].each do |item|
          item = {
            item_set:       item_set,
            item_set_block: item_set_block,
            item:           Item.find(item),
            count:          1
          }

          item_set_item = ItemSetItem.new(item)
          item_set_item.save
        end
      end
    end

    render nothing: true
  end
end
