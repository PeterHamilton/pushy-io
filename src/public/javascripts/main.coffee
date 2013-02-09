$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'clients', (clients) ->
    console.log clients
    socket.emit 'wtf', "YEAH, THE FUCK"
    console.log "sent"