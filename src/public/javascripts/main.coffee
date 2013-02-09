$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (text) ->
    $('#text').text text.toString()