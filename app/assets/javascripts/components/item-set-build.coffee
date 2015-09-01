class LoLA.Components.ItemSetBuild
  constructor: ->
    @$build   = $('.build')
    @disabled = true
    that      = this

    if @$build.hasClass('default')
      @showStats()
    else
      @$build.empty()
      $('.builds .stats .list').empty()

    @$build.sortable
      group  :
        name : 'item-set-build'
        pull : false
        put  : false

    @$build
      .on 'click', '.item .remove-button', (e) ->
        e.stopPropagation()
        $item = $(this).parents('.item')
        $item.trigger('lola.remove')
        $item.remove()
        that.update()

      .on 'lola.remove', '.item', ->
        that.update()

        removedItem = '.item[data-id="' + $(this).attr('data-id') + '"]'
        unless that.$build.find(removedItem).length > 1
          $('.item-set').find(removedItem).removeClass('selected')

    $('.item-set .item').on 'lola.remove', -> that.resolve($(this))

    # Locks build in view
    # $('.content-wrapper').on 'scroll', ->
    #   if typeof timeout != 'undefined'
    #     clearTimeout(timeout)
    #     timeout = null

    #   timeout = setTimeout(that.makeSticky, 250)

    # $(window).on 'resize', => @makeSticky()

  update: ->
    @disabled = @$build.find('.item').length > 5
    @showStats()
    @$build.find('.item').off('click.lola.add')

  showStats: ->
    $('.builds .stats .list').empty()

    @$build.find('.item').each ->
      name        = $(this).find('.name').html()
      description = $(this).find('.description').html()

      $('.builds .stats .list').append('<div class="gains"><div class="name">' + name + '</div><div class="description">' + description + '</div></div>')

  # Remove item from build if removed from item set
  resolve: ($item) ->
    @$build.find('.item[data-id="' + $item.attr('data-id') + '"]').remove()

  makeSticky: =>
    offsetTop    = $('.builds').offset().top + 360
    offsetBottom = $('.builds').height() + 60
    upperBound   = $('.content-wrapper').scrollTop()
    lowerBound   = $('.item-set').offset().top + $('.item-set').height()

    $('.builds').css('width', ($('.item-set').width() / 3) + 'px')

    if offsetTop < upperBound && offsetBottom < lowerBound
      $('.builds').addClass('sticky')
      $('.blocks').addClass('col-xs-offset-4')
    else
      $('.builds').removeClass('sticky')
      $('.blocks').removeClass('col-xs-offset-4')
