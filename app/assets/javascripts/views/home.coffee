class LoLA.Views.Home
  constructor: ->
    that = this

    $('.champion').on 'click', -> that.loadChampion($(this))

  loadChampion: ($champion) ->
