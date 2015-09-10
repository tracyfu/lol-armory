class ItemsController < ApplicationController
  def index
    @items = Item.includes(:images).order(:name)

    respond_to do |f|
      f.html
      f.json { render json: @items.as_json(only: [:id, :name, :description]) }
    end
  end
end
