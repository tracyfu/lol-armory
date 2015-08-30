class LoLA.Components.ItemSetBlock
  constructor: (@$itemSet, @$block) ->
    @$blockTitle = @$block.find('.block-title')
    that         = this

    @$blockTitle
      .on 'focus', ->
        $(this).val('')
        that.$itemSet.trigger('lola.change')

      .on 'blur', -> if $(this).val() == '' then $(this).val($(this).attr('data-title'))

