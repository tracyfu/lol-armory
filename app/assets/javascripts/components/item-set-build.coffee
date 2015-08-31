class LoLA.Components.ItemSetBuild
  constructor: ->
    @$build = $('.build')
    that    = this

    @$build.sortable
      group  :
        name : 'item-set'
        pull : false
      onAdd  : -> if that.$build.find('.item').length == 6 then that.$build.data('sortable').option('disabled', true)

    @$build
      .on 'click', '.item .remove-button', ->
        $item = $(this).parents('.item')
        $item.remove()
        $item.trigger('lola.remove')

      .on 'lola.remove', => @updateSortable()

    $('.item-set .item').on 'lola.remove', => @resolve()

  updateSortable: ->
    if @$build.find('.item').length < 6
      @$build.data('sortable').option('disabled', false)

  # Remove item from build if removed from item set
  resolve: ->
