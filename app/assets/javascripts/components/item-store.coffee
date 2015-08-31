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
      onRemove : -> that.$items = that.$store.find('.item')

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
    @$store.find('.search').on 'keyup', -> that.search($(this).val())
    @$items.on 'mousedown', -> $(this).popover('hide')
    @$store.find('.tags').on 'click', 'button', -> that.filter($(this))

  # Filter items by tags
  filter: ($filter) ->
    @$store.find('.search').val('')
    @$store.find('.tags button').removeClass('active')
    $filter.addClass('active')

    query = $filter.attr('data-tags')

    if query == 'All'
      @$items.show()
    else
      query = query.toLowerCase().split(',')

      @$items.each ->
        tags = $(this).attr('class').split(' ')
        if _.intersection(query, tags).length > 0 then $(this).show() else $(this).hide()

  # Filter items by search
  search: (query) ->
    query = $.trim(query.toLowerCase())

    @$items.each ->
      if $(this).attr('data-name').toLowerCase().indexOf(query) > -1
        $(this).show()
      else
        $(this).hide()
