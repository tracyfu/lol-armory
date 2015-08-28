class LoLA.Views.Home
  constructor: ->
    that = this
    @champion = key: $('.champion.masthead').attr('data-key')
    @itemSet = new LoLA.Components.ItemSet()

    $('.item').each -> $(this).popover { html: true, content: $(this).find('.item-tooltip').html(), trigger: 'hover' }

    $('.champion').on 'click', -> that.loadChampion($(this).data('id'))
    $('.create-button').on 'click', => @itemSet.generate(@champion)

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
    image = LoLA.Config.championImageURL(@champion['images'][0]['full'])
    roles = JSON.parse(@champion['tags']).join(', ')

    $masthead.find('.image').attr { src: image, alt: @champion['name'] }
    $masthead.find('.name').html(@champion['name'])
    $masthead.find('.title').html(@champion['title'])
    $masthead.find('.roles').html(roles)










