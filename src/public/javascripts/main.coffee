initialize_socket = ->
  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    $('.view-pane').hide()
    $('#loading').show()
    $('#text').html switch hand.type
      when 'dashboard'
        render_dashboard hand.payload
      # when 'text'
      #   hand.payload.message
      # when 'image'
      #   "<img src='#{hand.payload.url}'>"
      # when 'web'
      #   "<iframe width='100%' height='450px' src='#{hand.payload.url}'></image>"
     # text.toString()

clone_template = (id) ->
  $("##{id}").clone().attr('id', '')

render_dashboard = (payload) ->
  $('#dashboard').hide()
  render_notifications payload.notifications
  $('#loading').hide()
  $('#dashboard').slideDown()

render_notifications = (notifications, elem) ->
  elem.find('.notices').html('')
  $(notifications).each (index, notification) ->
    notification_elem = clone_template 'template-notification'

    notification_elem.find('.alert').addClass(notification.class)
    notification_elem.find('.body').html(notification.text)

    $('#notifications').append(notification_elem)

$ ->
  initialize_socket()

  # Clock
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000
