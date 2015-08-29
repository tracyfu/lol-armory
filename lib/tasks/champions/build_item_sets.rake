namespace :champions do
  desc 'Build recommended item sets for :champions'
  task :build_item_sets, [:champions] => :environment do |t, args|
    log = ActiveSupport::Logger.new('log/migrate.log')
    $stdout.sync = true

    start_time     = Time.now
    new_count      = 0
    skipped_count  = 0
    skipped        = []

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
    log.info result
    log.info "migrate:champions finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close
  end
end
