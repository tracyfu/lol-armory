class ApplicationController < ActionController::Base
  before_filter :get_champions
  protect_from_forgery with: :exception

  def get_champions
    @champions = Champion.includes(:images).order(:name)
  end
end
