class LoLA.Views.Home
  constructor: ->
    that = this
    $('.champion').on 'click', -> that.loadChampion($(this).data('id'))

  loadChampion: (id) ->
    $.ajax 'champions/' + id
      .error (response) ->
        throw new Error 'Champion could not be found'
      .success (response) =>
        @updateMasthead(response.champion)

  updateMasthead: (champion) ->
    $masthead = $('.champion.masthead')
    image = LoLA.Config.championImageURL(champion['images'][0]['full'])
    roles = JSON.parse(champion['tags']).join(', ')

    $masthead.find('.image').attr { src: image, alt: champion['name'] }
    $masthead.find('.name').html(champion['name'])
    $masthead.find('.title').html(champion['title'])
    $masthead.find('.roles').html(roles)
