class LoLA.Components.ItemSetBlock
  constructor: (@$itemSet, @$block) ->
    @$blockTitle = @$block.find('.block-title')

    @$blockTitle
      .on 'click', =>
        @$blockTitle.find('input').val('')
        @$itemSet.trigger('lola.change')

      .on 'blur', 'input', ->
        if $(this).val() == ''
          $(this).val($(this).attr('data-title'))

