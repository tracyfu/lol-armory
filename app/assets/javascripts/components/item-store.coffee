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

    @search = new LoLA.Components.Search @$store.find('.search'), @$items

    @filters = @$store.find('.filter').map ->
      new LoLA.Components.Search $(this), that.$items, 'filter', ($trigger) ->
        $('.item-store .search').val('')
        $('.item-store .filter').removeClass('active')
        $trigger.addClass('active')
