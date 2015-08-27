module ApplicationHelper
  def champion_image_tag(image, html_options = {})
    image_tag "#{Rails.application.config.cdn}/#{Rails.application.config.version}/img/champion/#{image}", class: 'image'
  end
end
