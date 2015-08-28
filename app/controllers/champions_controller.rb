class ChampionsController < ApplicationController
  def show
    champion = Champion.find(params[:id])
    @champion = champion.as_json(include: :images)
    @recommended_item_set = champion.recommended_item_set.as_json(include: [item_set_blocks: { include: [items: { include: [:images, :cost]}, item_set_items: { only: [:item_id, :count]}]}])

    @recommended_item_set['item_set_blocks'].each do |block|
      block['items'].each do |item|
        item['description'] = ApplicationController.helpers.format_item_tooltip(item['description'])
      end
    end

    respond_to do |f|
      f.json { render json: { champion: @champion, recommended_item_set: @recommended_item_set }, status: 200 }
    end
  end
end
