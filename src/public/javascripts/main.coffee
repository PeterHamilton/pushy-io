# Server - client communication
initialize_socket = ->
  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    $('body').removeClass('black')
    $('.view-pane').hide()
    $('#loading').show()
    console.log hand
    render hand

render = (hand) ->
  dust.render hand.type, hand.payload, (err, gen) ->
    $('#loading').hide()
    $('#loaded-content').html gen
    $('#loaded-content').slideDown()

$ ->
  initialize_socket()

  # Clock
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000
