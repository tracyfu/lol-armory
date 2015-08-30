class LoLA.Components.ItemStore
  constructor: ->
    @$store = $('.item-store')
    @$items = @$store.find('.item')
    that    = this

    @$store.find('.items').sortable
      group  :
        name : 'items'
        pull : 'clone'
        put  : false
      sort   : false

    @$store.find('.item').each ->
      $(this).popover
        html      : true
        content   : $(this).find('.item-tooltip').html()
        container : 'body'
        trigger   : 'hover'
        placement : 'left'
        delay     :
          show    : 150

    @$store.find('.toggle').on 'click', -> $('.content').toggleClass('store-open')
    @$items.on 'mousedown', -> $(this).popover('hide')
    @$store.find('.tags').on 'click', 'button', -> that.filter($(this).attr('data-tags'))

  filter: (query) ->
    if query == 'All'
      @$items.show()
    else
      query = query.split(',')

      @$items.each ->
        if $(this).attr('data-tags')
          tags = $(this).attr('data-tags').split(',')
          if _.intersection(query, tags).length > 0 then $(this).show() else $(this).hide()
        else
          $(this).hide()
