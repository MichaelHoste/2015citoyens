$ ->
  align_person = (person) ->
    positions = person.attr('id').split('-')
    y = parseInt(positions[1])
    if y < 25
      $('#person').removeClass('left')
      $('#person').addClass('right')
    else
      $('#person').removeClass('right')
      $('#person').addClass('left')

  trigger_facebook_share = ->
    FB.ui(
      method:  'feed',
      link:    'http://2015citoyens.be',
    )

  $('.submit').on('click', ->
    $('form').submit()
    return false
  )

  $('#squares div').on('mouseenter', ->
    $(this).css('border', '1px solid #AAAAAA')
    $('#person img').attr('src', $(this).data('picture'))

    if $(this).data('picture') != ""
      align_person($(this))
      $('#person .description .content').html($(this).data('text'))
      $('#person').show()
  )

  $('#squares div').on('mouseleave', ->
    $(this).css('border', '0px')
    $('#person').hide()
  )

  $(".fbshare").on('click', ->
    trigger_facebook_share()
  )

  if $("#trigger-facebook").length
    setTimeout(trigger_facebook_share, 2000)
