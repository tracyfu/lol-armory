class LoLA.Views.Home
  constructor: ->
    @champion  = key: $('.champion.masthead').attr('data-key')
    @itemStore = new LoLA.Components.ItemStore()
    @itemSet   = new LoLA.Components.ItemSet(@champion)
    that       = this

    $('.champion').on 'click', -> that.loadChampion($(this).data('id'))

  loadChampion: (id) ->
    $.ajax 'champions/' + id
      .error (response) ->
        throw new Error 'Champion could not be found'

      .success (response) =>
        @champion = response.champion
        @recommendedItemSet = response.recommended_item_set

        @updateMasthead()
        @itemSet.load(@recommendedItemSet)

  updateMasthead: ->
    $masthead = $('.champion.masthead')
    image     = LoLA.Config.championImageURL(@champion['images'][0]['full'])
    roles     = JSON.parse(@champion['tags']).join(', ')

    $masthead.attr
      'data-id'  : @champion['id']
      'data-key' : @champion['key']

    $masthead.find('.image').attr
      src: image
      alt: @champion['name']

    $masthead.find('.name').html(@champion['name'])
    $masthead.find('.title').html(@champion['title'])
    $masthead.find('.roles').html(roles)
