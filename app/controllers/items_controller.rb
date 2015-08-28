class ItemsController < ApplicationController
  def index
    @items = Item.includes(:images).order(:name)
  end
end
