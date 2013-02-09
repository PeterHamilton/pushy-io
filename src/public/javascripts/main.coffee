$ ->

  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    console.log "received"
    console.log hand
    $('#text').html switch hand.type
      when 'text'
        hand.payload.message
      when 'image'
        "<img src='#{hand.payload.url}'>"
      when 'web'
        "<iframe width='100%' height='450px' src='#{hand.payload.url}'></image>"

  # Clock
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000