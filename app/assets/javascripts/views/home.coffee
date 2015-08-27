class LoLA.Views.Home
  constructor: ->
    $('.champion').on 'click', => @loadChampion()

  loadChampion: ->
