namespace :champions do
  desc 'Build recommended item sets for :champions'
  task :build_item_sets, [:champions] => :environment do |t, args|
    log = ActiveSupport::Logger.new('log/migrate.log')
    $stdout.sync = true

    start_time     = Time.now
    new_count      = 0
    skipped_count  = 0
    skipped        = []

    puts 'Building item sets...'
    log.info "champions:build_item_sets started at #{start_time}"

    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }

    # Champion Recommended Items Documentation: https://developer.riotgames.com/api/methods#!/968/3326
    # Item Set Documentation: https://developer.riotgames.com/docs/item-sets
    if args.has_key?(:champions)
      champions = args.champions.split.map do |champion|
        client.static.champion.get(champion, champData: 'recommended')
      end
    else
      champions = client.static.champion.get(champData: 'recommended')
    end

    champions.each do |champion|
      champion = champion.to_h

      if champion.key?(:recommended)
        recommended_set = (champion[:recommended].select { |set| (set['map'] == 'SR' || set['map'] == '1') && set['mode'] == 'CLASSIC' }).first

        if recommended_set.nil?
          skipped << champion[:name]
          skipped_count = skipped_count + 1
          print 'x'
        else
          recommended_set.symbolize_keys!
          recommended_set[:champion]   = Champion.find(champion[:id])
          recommended_set[:map]        = 'SR'
          recommended_set[:set_type]   = recommended_set.delete :type
          recommended_set[:priority]   = recommended_set[:priority] || false
          recommended_set[:created_by] = 'Riot'

          destroyed = ItemSet.where(['champion_id = ? and created_by = ?', champion[:id], 'Riot']).destroy_all
          ItemSetItem.where('item_set_id = ?', destroyed).delete_all

          item_set = ItemSet.new(recommended_set.except :blocks)
          item_set.save

          new_count = new_count + 1
          print '.'

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

    puts
    puts

    if skipped_count > 0
      skipped = "Skipped #{skipped.join}"

      puts skipped
      log.info skipped
    end

    end_time = Time.now
    result = "#{new_count} new records, #{skipped_count} records skipped of #{champions.length} total records"

    puts result
    puts
    log.info result
    log.info "migrate:champions finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close

    # Run if processing all champions or if the args.champions includes Nidalee
    if !args.has_key?(:champions) || (args.has_key?(:champions) && args.champions.split.include?('76'))
      Rake::Task['champions:build_item_set_for_nidalee'].invoke
    end
  end

  # Nidalee is the only champ without recommended items for Summoner's Rift - Classic Mode
  desc 'Build a recommended item set for Nidalee from in-game data'
  task build_item_set_for_nidalee: :environment do
    log = ActiveSupport::Logger.new('log/migrate.log')
    start_time = Time.now

    log.info "champions:build_item_set_for_nidalee started at #{start_time}"

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

      destroyed = ItemSet.where("champion_id = 76 and created_by = 'Riot'").destroy_all
      ItemSetItem.where('item_set_id = ?', destroyed).delete_all

      item_set = ItemSet.new(recommended_set)
      item_set.save

      puts 'Patching Nidalee...'

      result = '1 new record of 1 total records'
      puts result
      puts
      log.info result

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

    end_time = Time.now
    log.info "migrate:build_item_set_for_nidalee finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close
  end
end
