module ApplicationHelper
  def champion_image_tag(image)
    image_tag "#{Rails.application.config.cdn}/#{Rails.application.config.version}/img/champion/#{image}", class: 'champion image'
  end
end
