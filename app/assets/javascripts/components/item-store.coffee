class LoLA.Components.ItemStore
  constructor: ->
    @$store = $('.item-store')

    @$store.on 'click', ->$('.content').toggleClass('store-open')
