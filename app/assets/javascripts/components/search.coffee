class LoLA.Components.Search
  constructor: (@$trigger, @$results, @strategy = 'search', @callback = ->) ->
    if @strategy == 'search'
      # Search initiated by user input
      @$trigger
        .on 'focus', -> $(this).val('')
        .on 'keyup', => @search(@$trigger.val())
    else
      # Search initiated by filter
      @$trigger.on 'click', => @filter(@$trigger.data('filters'))

  # Search for a specific string
  search: (query) ->
    query = $.trim(query).toLowerCase()

    @$results.each ->
      if $(this).text().toLowerCase().indexOf(query) > -1
        $(this).show()
      else
        $(this).hide()

    @callback()

  # Find the intersection of two arrays
  filter: (filter) ->
    if filter == ''
      @$results.show()
    else
      filter = filter.toLowerCase().split(',')

      @$results.each ->
        tags = $(this).attr('class').split(' ')

        if _.intersection(filter, tags).length > 0
          $(this).show()
        else
          $(this).hide()

    @callback(@$trigger)
