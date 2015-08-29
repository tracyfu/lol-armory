class LoLA.Components.ItemSet
  constructor: (@champion) ->
    @$itemSet = $('.item-set')
    @$item    = @$itemSet.find('.item')
    @build    = new LoLA.Components.ItemSetBuild()

    @initialize()

  initialize: ->
    that = this

    @$itemSet.find('.items').sortable
      group  :
        name : 'item-set'
        pull : 'clone'
        put  : ['items']
      onAdd  : (e) ->
        $(e.item).data('bs.popover').options.placement = 'right'

    @$item.each ->
      $(this).popover
        html      : true
        content   : $(this).find('.item-tooltip').html()
        container : 'body'
        trigger   : 'hover'

    $('.json-output').html('')

    @$item.on 'mousedown', -> $(this).popover('hide')
    @$item.on 'click', -> that.build.addItem($(this))
    $('.create-button').on 'click', => @generate(@champion)

  load: (itemSet) ->
    that = this

    $('.item-set .block').remove()

    $.each itemSet['item_set_blocks'], (index, block) ->
      $itemSet = that.$itemSet

      $itemSet.append('<section class="block"><h1>' + block['block_type'] + '</h1></section>')

      $.each block['items'], (index, item) ->
        data =
          id          : item['id']
          name        : item['name']
          image       : LoLA.Config.itemImageURL(item['images'][0]['full'])
          cost        : item['cost']['total']
          description : item['description']

        item = JST['templates/item'](data)
        $itemSet.find('section:eq(' + index + ')').append(item)

    @initialize()

  generate: (champion) ->
    path = 'C:\\Riot Games\\League of Legends\\Config\\Champions\\<span class="champion">' + champion['key'] + '</span>\\Recommended\\'
    file = '<span class="file">LoLA_ItemSet_' + (new Date()).toISOString().slice(0, 10).replace(/-/g,"") + '.json</file>'

    $('.path').html(path + file)

    itemSet =
      title    : $('.item-set > h1').text()
      type     : 'custom'
      map      : 'any'
      mode     : 'any'
      priority : false
      sortrank : 0
      blocks   : []

    $('.item-set .block').each ->
      block =
        type                : $(this).find('h1').text()
        recMath             : false
        minSummonerLevel    : -1
        maxSummonerLevel    : -1
        showIfSummonerSpell : ''
        hideIfSummonerSpell : ''
        items               : []

      $(this).find('.item').each ->
        block['items'].push
          id    : $(this).attr('data-id')
          count : 1

      itemSet['blocks'].push(block)

    $('.json-output').html(JSON.stringify(itemSet, null, 2))
