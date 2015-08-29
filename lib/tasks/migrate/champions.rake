namespace :migrate do
  desc 'Migrate champions from the LoL Static Data API'
  task champions: :environment do
    log = ActiveSupport::Logger.new('log/migrate.log')
    $stdout.sync = true

    start_time   = Time.now
    new_count    = 0
    update_count = 0
    error_count  = 0

    log.info "migrate:champions started at #{start_time}"

    require 'lol'

    client    = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    champions = client.static.champion.get(champData: 'all')

    champions.each do |c|
      c = c.to_h
      champion = Champion.find_or_initialize_by(id: c[:id])

      if champion.persisted?
        update_count = update_count + 1
      else
        new_count = new_count + 1
      end

      if champion.update(c.slice(:id, :key, :name, :title, :tags))
        if c.key?(:image)
          c[:image][:imageable] = champion

          image = Image.new(c[:image])
          image.save
        end

        print '.'
      else
        error_count = error_count + 1
        print 'x'
      end
    end

    end_time = Time.now
    result = "#{new_count} new records, #{update_count} updated records, #{error_count} failures of #{champions.length} total records"

    puts
    puts result

    log.info result
    log.info "migrate:champions finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close

    Rake::Task['champions:build_item_sets'].invoke

    # # Nidalee is the only champ without recommended items for Summoner's Rift - Classic Mode
    # # Builds a recommended item set from in-game data
    # nidalee = Champion.find_by(id: 76)

    # unless nidalee.nil?
    #   recommended_set = {
    #     champion:   nidalee,
    #     map:        'SR',
    #     mode:       'CLASSIC',
    #     set_type:   'riot',
    #     created_by: 'Riot',
    #     title:      'NidaleeSR'
    #   }

    #   item_set = ItemSet.new(recommended_set)
    #   item_set.save

    #   items = [
    #     [1056, 2003, 3340],            # Starting:    [1056: Doran's Ring, 2003: Health Potion, 3340: Warding Totem (Trinket)]
    #     [3020, 3165, 3089],            # Essential:   [3020: Sorcerer's Shoes, 3165: Morellonomicon, 3089: Rabadon's Deathcap]
    #     [3135, 3100, 3285],            # Offensive:   [3135: Void Staff, 3100: Lich Bane, 3285: Luden's Echo]
    #     [3025, 3174, 3157],            # Defensive:   [3025: Iceborn Guantlet, 3174: Athene's Unholy Grail, 3157: Zhonya's Hourglass]
    #     [2003, 2004, 2044, 2043, 2139] # Consumables: [2003: Health Potion, 2004: Mana Potion, 2044: Stealth Ward, 2043: Vision Ward, 2139: Elixir of Sorcery]
    #   ]

    #   ['Starting', 'Essential', 'Offensive', 'Defensive', 'Consumables'].each_with_index do |block, index|
    #     block = {
    #       item_set:           item_set,
    #       block_type:         block,
    #       rec_math:           false,
    #       min_summoner_level: -1,
    #       max_summoner_level: -1
    #     }

    #     item_set_block = ItemSetBlock.new(block)
    #     item_set_block.save

    #     items[index].each do |item|
    #       item = {
    #         item_set:       item_set,
    #         item_set_block: item_set_block,
    #         item:           Item.find(item),
    #         count:          1
    #       }

    #       item_set_item = ItemSetItem.new(item)
    #       item_set_item.save
    #     end
    #   end
    # end
  end
end
