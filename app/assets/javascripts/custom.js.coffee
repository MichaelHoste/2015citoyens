$ ->
  align_person = (person) ->
    positions = person.attr('id').split('-')
    y = parseInt(positions[1])
    if y < 25
      person.removeClass('right')
      person.addClass('left')
    else
      person.removeClass('left')
      person.addClass('right')

  $('.submit').on('click', ->
    $('form').submit()
    return false
  )

  $('#squares div').on('mouseenter', ->
    $(this).css('border', '1px solid #AAAAAA')
    $('#person img').attr('src', $(this).data('picture'))

    if $(this).data('picture') != ""
      align_person($(this))
      $('#person').show()
  )

  $('#squares div').on('mouseleave', ->
    $(this).css('border', '0px')
    $('#person').hide()
  )
