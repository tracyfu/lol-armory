class LoLA.Components.ItemSetBlock
  constructor: (@$set, @$block) ->
    @$title = @$block.find('.block-title')
    @$items = @$block.find('.items')
    _this   = this

    @$items.sortable
      group     :
        name    : 'block'
        pull    : false
        put     : ['items']
      draggable : '.item'
      animation : 150
      onAdd     : (e) -> $(e.item).data('bs.popover').options.placement = 'right'

    @$title
      .on 'click', 'input', ->
        $(this).focus().val('')

      .on 'blur', 'input', ->
        if $(this).val() == ''
          $(this).val($(this).attr('data-title'))
        else
          _this.$set.trigger('lola.itemset.change')

      .on 'keyup', 'input', (e) ->
        _this.$set.trigger('lola.itemset.change')
        $(this).blur() if e.which == 13
