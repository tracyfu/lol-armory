class LoLA.Components.Searchable
  constructor: (@$searchable, @$results, @callback = ->) ->
    @$search = @$searchable.find('input.filter')
    @$filter = @$searchable.find('button.filter')
    @$clear  = @$searchable.find('.clear.filter')
    that     = this

    # Search initiated by user input
    @$search
      .on 'focus', ->
        $(this).val('')
        that.filter($(this))

      .on 'keyup', ->
        that.filter($(this))

    # Search initiated by clickable filter
    @$filter.on 'click', -> that.filter($(this))

  # Filter on tags
  filter: ($trigger) ->
    if $trigger.hasClass('clear')
      @clear()
    else
      @$clear.removeClass('selected')

      # Select group
      if $trigger.parent('.group').length
        @$filter.removeClass('selected')
      else
        @$searchable.find('.group > .filter').removeClass('selected')

      $trigger.toggleClass('selected')
      $selected = @$searchable.find('button.filter.selected')

      if $selected.length
        filters = $.map $selected, (selected) -> $(selected).data('filters').toLowerCase().split(',')

        @$results.each ->
          tags = $(this).attr('class').split(' ')

          # Filter by group or tags
          if $trigger.parent('.group').length
            match = _.intersection(filters, tags).length
          else
            match = _.intersection(filters, tags).length == filters.length

          if match then $(this).show() else $(this).hide()
      else
        @clear()

    @search()

  # Search for a specific string
  search: ->
    query = $.trim(@$search.val().toLowerCase())

    if query.length
      @$results.each -> $(this).hide() if $(this).text().toLowerCase().indexOf(query) < 0

    @callback(@$searchable)

  # Reset results
  clear: ->
    @$searchable.find('.filter').removeClass('selected')
    @$clear.addClass('selected')
    @$results.show()
