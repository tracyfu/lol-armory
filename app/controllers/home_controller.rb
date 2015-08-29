class HomeController < ApplicationController
  def index
    @default_champion = @champions[rand(@champions.length)]
  end
end
