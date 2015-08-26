class HomeController < ApplicationController
  def index
    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    @champions = client.static.champion.get(champData: 'image')
  end

  def import
    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    items = client.static.item.get(itemListData: 'all')

    items.each do |i|
      i = i.to_h
      item = Item.new(i.except(:image, :gold))

      if item.save
        if i.key?(:image)
          i[:image][:imageable_id] = i[:id]
          i[:image][:imageable_type] = 'Item'
          image = Image.new(i[:image])
          image.save
        end

        if i.key?(:gold)
          i[:gold][:item_id] = i[:id]
          cost = Cost.new(i[:gold])
          cost.save
        end
      end
    end

    render nothing: true
  end
end
