class ChampionsController < ApplicationController

  def show
     champion = Champion.find(params[:id])
    @champion = champion.as_json(root: true, include: [:images, item_sets: { include: [item_set_blocks: { include: :item_set_items }]}])

    respond_to do |f|
      f.json { render json: @champion, status: 200 }
    end
  end
end
