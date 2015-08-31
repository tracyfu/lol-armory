class HomeController < ApplicationController
  def index
    # @default_champion = @champions[rand(@champions.length)]
    @default_champion = @champions.find(89)
    @items = Item.includes(:images, :cost).order(:name)
  end
end
