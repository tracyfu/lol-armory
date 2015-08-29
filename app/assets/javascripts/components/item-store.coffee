class LoLA.Components.ItemStore
  constructor: ->
    @$store = $('.item-store')
    @$item  = @$store.find('.item')

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

    @$store.on 'click', -> $('.content').toggleClass('store-open')
    @$item.on 'mousedown', -> $(this).popover('hide')

