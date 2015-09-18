class LoLA.Views.Home
  constructor: ->
    @champion  = $('.champion.masthead').data()
    @search    = new LoLA.Components.ChampionFilter()
    @itemStore = new LoLA.Components.ItemStore()
    @itemSet   = new LoLA.Components.ItemSet(@champion)
    that       = this

    $('.champions')
      .on 'click', -> $(this).find('ul').toggleClass('active')
      .on 'click', '.champion', -> that.loadChampion($(this).data('id'))

  loadChampion: (id) ->
    $.ajax 'champions/' + id
      .error (response) ->
        throw new Error 'Champion could not be found'

      .success (response) =>
        @champion = response.champion
        @recommendedItemSet = response.recommended_item_set

        @updateMasthead()
        @itemSet.champion = @champion
        @itemSet.load(@recommendedItemSet)

  updateMasthead: ->
    $masthead = $('.champion.masthead')
    image     = LoLA.Config.championImageURL(@champion['images'][0]['full'])
    roles     = JSON.parse(@champion['tags']).join(', ')

    $masthead.attr
      'data-id'  : @champion['id']
      'data-key' : @champion['key']

    $masthead.find('.image').attr(style: 'background-image: url(' + image + ')')

    $masthead.find('.name').html(@champion['name'])
    $masthead.find('.title').html(@champion['title'])
    $masthead.find('.roles').html(roles)
