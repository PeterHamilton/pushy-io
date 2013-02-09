$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  username = prompt "Username:", ""

  $('#send').click ->
    socket.emit 'push',
      author: username
      text: $('#input').val()
    console.log "sent"