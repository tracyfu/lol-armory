class LoLA.Components.ChampionFilter
  constructor: ->
    @$search    = $('.champions .filter')
    @$champions = $('.champions .champion')
    that        = this

    @$search.on 'keyup', -> that.filter($(this).val())

  filter: (query) ->
    query = $.trim(query.toLowerCase())

    @$champions.each ->
      if $(this).attr('class').indexOf(query) > -1
        $(this).parent('li').addClass('active')
      else
        $(this).parent('li').removeClass('active')
