class LoLA.Components.ItemStore
  constructor: ->
    @$store = $('.item-store')
    @$items = @$store.find('.item')
    that    = this

    @$store.find('.items').sortable
      group    :
        name   : 'items'
        pull   : 'clone'
        put    : false
      sort     : false
      onRemove : -> that.$items = that.$store.find('.item')

    @$items.each ->
      $(this).popover
        html      : true
        content   : $(this).find('.item-tooltip').html()
        container : 'body'
        trigger   : 'hover'
        placement : 'left'
        delay     :
          show    : 150

    @$store
      .on 'click', '.toggle', -> $('.content').toggleClass('store-open')
      .on 'mousedown', '.item', -> $(this).popover('hide')

    @searchable = new LoLA.Components.Searchable @$store, @$items
