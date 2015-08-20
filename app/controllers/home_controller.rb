class HomeController < ApplicationController
  def index
    require 'lol'

    client = Lol::Client.new Rails.application.secrets.lol_api_key, { region: 'na' }
    @champions = client.static.champion.get(champData: 'image')
  end
end
