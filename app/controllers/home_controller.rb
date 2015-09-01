class HomeController < ApplicationController
  def index
    # Leona
    @default_champion = @champions.find(89)
    @default_build = [3401, 3117, 2045, 3143, 3190, 3110]

    @items = Item.includes(:images, :cost).order(:name)
  end
end
