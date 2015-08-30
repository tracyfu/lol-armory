class LoLA.Components.ItemSet
  constructor: (@champion) ->
    @$itemSet  = $('.item-set')
    @$setTitle = @$itemSet.find('.set-title')
    @defaults  = title: 'Recommended'
    that       = this

    @$setTitle
      .on 'focus', ->
        $(this).val('')
        that.$itemSet.trigger('lola.change')

      .on 'blur' , -> if $(this).val() == '' then $(this).val(that.defaults['title'])

    @$itemSet.on 'lola.change', -> $('.path, .json-output').html('')

    @initialize()

  initialize: ->
    @$block = @$itemSet.find('.block')
    @$item  = @$itemSet.find('.item')
    @build  = new LoLA.Components.ItemSetBuild()
    that    = this

    @$itemSet.find('.items').sortable
      group  :
        name : 'item-set'
        pull : 'clone'
        put  : ['items']
      onAdd  : (e) -> $(e.item).data('bs.popover').options.placement = 'right'

    @$item.each ->
      $(this).popover
        html      : true
        content   : $(this).find('.item-tooltip').html()
        container : 'body'
        trigger   : 'hover'

    @$block.each ->
      new LoLA.Components.ItemSetBlock(that.$itemSet, $(this))

    $('.path, .json-output').html('')

    @$item.on 'mousedown', -> $(this).popover('hide')
    @$item.on 'click', -> that.build.addItem($(this))
    $('.create-button').on 'click', => @generate(@champion)

  load: (itemSet) ->
    that = this

    @$setTitle.val(@defaults['title'])
    @$itemSet.find('.block').remove()

    $.each itemSet['item_set_blocks'], (index, block) ->
      $itemSet = that.$itemSet

      $block = $(JST['templates/block'](title: block['block_type'], placeholder: 'Block Title'))
      $itemSet.find('.blocks').append($block)

      $.each block['items'], (index, item) ->
        data =
          id          : item['id']
          classes     : $.parseJSON(item['tags']).join(' ').toLowerCase()
          name        : item['name']
          image       : LoLA.Config.spriteImageURL(item['images'][0]['sprite'])
          imageX      : if item['images'][0]['x'] == 0 then 0 else '-' + item['images'][0]['x'] + 'px'
          imageY      : if item['images'][0]['y'] == 0 then 0 else '-' + item['images'][0]['y'] + 'px'
          imageW      : item['images'][0]['w']
          imageH      : item['images'][0]['h']
          cost        : item['cost']['total']
          description : item['description']

        $item = $(JST['templates/item'](data))
        $itemSet.find('section:eq(' + index + ') .items').append($item)

    @initialize()

  generate: (champion) ->
    path = 'C:\\Riot Games\\League of Legends\\Config\\Champions\\<span class="champion">' + champion['key'] + '</span>\\Recommended\\'
    file = '<span class="file">LoLA_ItemSet_' + champion['key'] + '_' + (new Date()).toISOString().slice(0, 10).replace(/-/g,"") + '.json</file>'

    $('.path').html(path + file)

    title = $('<div>').text(@$setTitle.val()).html()

    itemSet =
      title    : title
      type     : 'custom'
      map      : 'any'
      mode     : 'any'
      priority : false
      sortrank : 0
      blocks   : []

    @$itemSet.find('.block').each ->
      title = $('<div>').text($(this).find('.block-title').val()).html()

      block =
        type                : title
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
