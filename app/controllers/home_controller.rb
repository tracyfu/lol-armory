class HomeController < ApplicationController
  def index
    @default_champion = @champions[rand(@champions.length)]
    @items = Item.includes(:images, :cost).order(:name)
  end
end
