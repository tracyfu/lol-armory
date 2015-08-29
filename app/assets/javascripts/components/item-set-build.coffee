class LoLA.Components.ItemSetBuild
  constructor: ->
    $('.build').sortable
      group  :
        name : 'item-set'
        pull : false

  addItem: ($item) ->
    $('.build').append($item)
