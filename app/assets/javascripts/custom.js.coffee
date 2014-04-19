$ ->
  align_person = (person) ->
    positions = person.attr('id').split('-')
    x = parseInt(positions[0])
    y = parseInt(positions[1])
    if y < 25
      $('#person').removeClass('left')
      $('#person').addClass('right')
    else
      $('#person').removeClass('right')
      $('#person').addClass('left')

    if x < 12
      $('#person').removeClass('bottom')
      $('#person').removeClass('center')
      $('#person').addClass('top')
    else if x >= 12 && x < 28
      $('#person').removeClass('bottom')
      $('#person').removeClass('top')
      $('#person').addClass('center')
    else
      $('#person').removeClass('top')
      $('#person').removeClass('center')
      $('#person').addClass('bottom')

  trigger_facebook_share = ->
    FB.ui(
      method:      'feed',
      link:        'http://2015citoyens.be',
      description: "Je fais partie d'une mosaique de 2015 citoyens concernés par Mons 2015, rejoins-moi et donne ton avis !"
    )

  $('.action-1 .content .fb-connect').on('click', ->
    $(this).hide()
    $(this).next().show()
    return true
  )

  $('.submit').on('click', ->
    if $('.input-description').val() == '' || $('.fb-connect').length
      alert("Vous devez uploader votre photo et ajouter un message personnel.")
      return false

    $(this).hide()
    $(this).next().show()

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

  $('.fb-join').on('click', ->
    $('.subscription-link').hide()
    $('.subscription').show()
    false
  )

  if $('#current-user').length
    $('.subscription-link').hide()
    $('.subscription').show()

  if $("#trigger-facebook").length
    setTimeout(trigger_facebook_share, 2000)
