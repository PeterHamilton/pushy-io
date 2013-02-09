$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  username = prompt "Username:", ""

  $('#send').click ->
    type = $('#inputType').val()
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