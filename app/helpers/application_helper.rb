module ApplicationHelper
  def sprite_image_tag(image)
    x = image.x == 0 ? 0 : "-#{image.x}px"
    y = image.y == 0 ? 0 : "-#{image.y}px"

    content_tag :div, '', class: 'image', style: "background: url('#{Rails.application.config.image_url}sprite/#{image.sprite}') #{x} #{y}; width: #{image.w}px; height: #{image.h}px;"
  end

  def champion_image_tag(image, type = 'image')
    if type == 'sprite'
      sprite_image_tag(image)
    else
      image_tag "#{Rails.application.config.image_url}champion/#{image.full}", class: 'image'
    end
  end

  def item_image_tag(image, type = 'image')
    if type == 'sprite'
      sprite_image_tag(image)
    else
      image_tag "#{Rails.application.config.image_url}item/#{image.full}", class: 'image'
    end
  end
end
