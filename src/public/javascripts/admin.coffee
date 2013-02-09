$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  username = prompt "Username:", ""
  $('#input-type button:not(.disabled)').click ->
    type = $(this).data 'type'
    $('#input-form .row-fluid').hide()
    $('#input-form .row-fluid').has("#input-#{type}").show()
    $('#send').data 'type', type

  $('#send').click ->
    type = $('#send').data 'type'
    value = $("#input-#{type}").val()
    socket.emit 'push',
      author: username
      type: type
      payload: switch type
        when 'text'
          message: value
        when 'image', 'web'
          url: value

    console.log "sent"