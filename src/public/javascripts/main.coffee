initialize_socket = ->
  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    $('body').removeClass('black')
    $('.view-pane').hide()
    $('#loading').show()
    console.log hand
    switch hand.type
      when 'dashboard'
        render_dashboard hand.payload
      when 'image'
        render_image hand.payload
      # when 'text'
      #   hand.payload.message
      # when 'image'
      #   "<img src='#{hand.payload.url}'>"
      when 'web'
        render_website hand.payload
     # text.toString()

clone_template = (id) ->
  $("##{id}").clone().attr('id', '')

render_dashboard = (payload) ->
  $('#dashboard').hide()
  render_notifications payload.notifications
  $('#loading').hide()
  $('#dashboard').slideDown()

render_notifications = (notifications) ->
  $('#notifications').html('')
  $(notifications).each (index, notification) ->
    notification_elem = clone_template 'template-notification'
    if notification.classes?
      notification_elem.find('.alert').addClass(notification.classes.join(" "))
    notification_elem.find('.body').html(notification.text)
    notification_elem.find('.title').html("#{notification.author} // #{notification.title}")

    $('#notifications').append(notification_elem)

render_website = (payload) ->
  $('#website-iframe').html('')
  iframe = '<iframe frameborder="0" width="100%"" height="800px" src="' + payload.url + '"/>'
  $('#website-iframe').html(iframe)
  $('#loading').hide()
  $('#website-iframe').slideDown()

render_image = (payload) ->
  $('body').addClass('black')
  $('#image-container').hide()
  $('#image-container img').attr 'src', payload.url
  $('#loading').hide()
  $ ->
    $('#image-container').slideDown()


$ ->
  initialize_socket()

  # Clock
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000
