module ItemsHelper
  def recipe_tree(item)
    require 'json'

    content_tag(:div, class: 'recipe') do
      if item.from.nil?
        content_tag(:div, item_image_tag(item.images.first), class: 'ingredient')
      else
        concat(content_tag(:div, item_image_tag(item.images.first), class: 'ingredient'))

        JSON.parse(item.from).collect do |ingredient|
          concat(recipe_tree(Item.includes(:images).find(ingredient)))
        end
      end
    end
  end

  # Replace invalid HTML tags
  def format_item_description(content)
    # Replace font tags
    content.gsub!(/<font color='#[a-fA-F0-9]{3,6}'>/, '<highlight>')
    content.gsub!(/<\/font>/, '</highlight>')
    # Replace non-HTML tags
    content.gsub!(/(<(?!br|i)([^\/][^>]+)>)/) { "<div class=\"#{($2).downcase}\">" }
    content.gsub!(/<\/[^i][a-zA-Z]+>/, '</div>')

    content.html_safe
  end
end
