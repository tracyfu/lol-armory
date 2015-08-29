class LoLA.Components.ItemStore
  constructor: ->
    @$store = $('.item-store')

    @$store.on 'click', ->$('.content').toggleClass('store-open')
    @$store.find('.items').sortable
      group: 'items'
      pull:  'clone'
      put:   false
