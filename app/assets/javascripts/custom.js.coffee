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

trigger_subscription = ->
  $('.subscription-link').hide()
  $('.subscription').show()
  if not $('.fbshare').length
    $('p.lead.remaining').hide()

bind_fb_connect = ->
  $('.action-1 .content .fb-connect').on('click', ->
    $(this).hide()
    $(this).next().show()
    return true
  )

bind_fb_share = ->
  $(".fbshare").on('click', ->
    trigger_facebook_share()
  )

bind_validation_error = ->
  $('.submit').on('click', ->
    if $('.input-description').val() == '' || $('.fb-connect').length
      alert("Vous devez uploader votre photo et ajouter un message personnel.")
      return false

    $(this).hide()
    $(this).next().show()

    $('form').submit()
    return false
  )

mouse_enter = (square) ->
  square.css('border', '1px solid #AAAAAA')

  if square.data('picture') != ""
    $('#person img').attr('src', '') # don't display previous image during loading of new image
    $('#person img').attr('src', square.data('picture'))
    align_person(square)
    $('#person .description .content').html(square.data('text'))
    $('#person').css('zIndex', 1)
    $('#person').show().css('opacity', 1.0)

mouse_leave = (square) ->
  square.css('border', '0px')
  $('#person').css('opacity', 0.0)

bind_mouse_on_picture = ->
  $('#squares div').on('mouseenter', ->
    mouse_enter($(this))
  )

  $('#squares div').on('mouseleave', ->
    mouse_leave($(this))
  )

bind_join = ->
  $('.join').on('click', ->
    trigger_subscription()
    false
  )

hide_person_div = ->
  if $('#person').css('opacity') == '0'
    $('#person').css('zIndex', -2)

random_click = ->
  if not window.on_mozaic
    squares = $('#squares div[data-picture!=""]')
    total   = squares.length
    random  = Math.round(Math.random()*total)
    random_element = squares.eq(random)
    mouse_enter(random_element)
    time = 1500 + 7000 / 200 * random_element.data('text').length
    window.leave_timeout = setTimeout((-> mouse_leave(random_element)), time)
    window.enter_timeout = setTimeout(random_click, time+1000)

$ ->
  bind_fb_connect()
  bind_fb_share()
  bind_validation_error()
  bind_mouse_on_picture()
  bind_join()

  if $('#current-user').length
    trigger_subscription()

  if $("#trigger-facebook").length
    setTimeout(trigger_facebook_share, 2000)

  setInterval(hide_person_div, 1000)
  window.random_timeout = setTimeout(random_click, 1000)

  $('#squares').on('mouseenter', ->
    window.on_mozaic = true
  )

  $('#squares').on('mouseleave', ->
    window.on_mozaic = false
    clearTimeout(window.leave_timeout)
    clearTimeout(window.enter_timeout)
    clearTimeout(window.random_timeout)

    window.random_timeout = setTimeout(random_click, 1000)
  )
