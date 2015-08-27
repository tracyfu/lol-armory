class ChampionsController < ApplicationController

  def show
    @champion = Champion.find(params[:id])

    respond_to do |f|
      f.json { render json: @champion.to_json(include: [:images, :item_sets]), status: 200 }
    end
  end
end
