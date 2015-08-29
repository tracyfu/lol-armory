namespace :migrate do
  desc 'Migrate items from the LoL Static Data API'
  task items: :environment do
    log = ActiveSupport::Logger.new('log/migrate.log')
    $stdout.sync = true

    start_time   = Time.now
    new_count    = 0
    update_count = 0
    error_count  = 0

    puts 'Migrating items...'
    log.info "migrate:items started at #{start_time}"

    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    items  = client.static.item.get(itemListData: 'all')

    items.each do |i|
      i    = i.to_h
      i    = Hash[i.map { |k, v| [k.to_s.underscore.to_sym, v] }]
      item = Item.find_or_initialize_by(id: i[:id])

      if item.persisted?
        update_count = update_count + 1
      else
        new_count = new_count + 1
      end

      if item.update(i.except(:image, :gold))
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

        print '.'
      else
        error_count = error_count + 1
        print 'x'
      end
    end

    end_time = Time.now
    result = "#{new_count} new records, #{update_count} updated records, #{error_count} failures of #{items.length} total records"

    puts
    puts
    puts result
    puts

    log.info result
    log.info "migrate:items finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close

    Rake::Task['items:fix_descriptions'].invoke
  end
end
