namespace :migrate do
  desc 'Migrate champions from the LoL Static Data API'
  task champions: :environment do
    log = ActiveSupport::Logger.new('log/migrate.log')
    $stdout.sync = true

    start_time   = Time.now
    new_count    = 0
    update_count = 0
    error_count  = 0

    puts 'Migrating champions...'
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
    puts
    puts result
    puts

    log.info result
    log.info "migrate:champions finished at #{end_time} and took #{end_time - start_time} seconds"
    log.close

    Rake::Task['champions:build_item_sets'].invoke
  end
end
