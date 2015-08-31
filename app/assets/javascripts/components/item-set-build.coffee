class LoLA.Components.ItemSetBuild
  constructor: ->
    @$build = $('.build')
    that    = this

    @$build.empty()
    $('.builds .stats .list').empty()

    @$build.sortable
      group  :
        name : 'item-set'
        pull : false
      onAdd  : -> that.updateSortable()

    @$build
      .on 'click', '.item .remove-button', ->
        $item = $(this).parents('.item')
        $item.remove()
        $item.trigger('lola.remove')

      .on 'lola.remove', => @updateSortable()

    $('.item-set .item').on 'lola.remove', -> that.resolve($(this))

    # Locks build in view
    $('.content-wrapper').on 'scroll', ->
      if typeof timeout != 'undefined'
        clearTimeout(timeout)
        timeout = null

      timeout = setTimeout(that.makeSticky, 250)

    $(window).on 'resize', => @makeSticky()

  showStats: ->
    $('.builds .stats .list').empty()

    @$build.find('.item').each ->
      name        = $(this).find('.name').html()
      description = $(this).find('.description').html()

      $('.builds .stats .list').append('<div class="gains"><div class="name">' + name + '</div><div class="description">' + description + '</div></div>')

  updateSortable: ->
    if @$build.find('.item').length == 6
      @$build.data('sortable').option('disabled', true)
    else
      @$build.data('sortable').option('disabled', false)

    @showStats()

  # Remove item from build if removed from item set
  resolve: ($item) ->
    @$build.find('.item[data-id="' + $item.attr('data-id') + '"]').remove()
    @updateSortable()

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
