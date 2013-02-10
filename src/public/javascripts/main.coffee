currentType = undefined

# Server - client communication
initialize_socket = ->
  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    $('#loading').show()
    console.log hand
    render hand

  socket.on 'chat-data', (hand) ->
    if currentType is 'chat'
      dust.render 'chat_message', hand, (err, gen) ->
        $('#chat-messages').prepend gen

render = (hand) ->
  hidingDuration = 800
  showingDuration = 800
  dust.render hand.type, hand.payload, (err, gen) ->
    $('#loading').hide()
    $('#loaded-content').animate 'opacity': '0.0', hidingDuration, ->
      $('#loaded-content').html gen
      currentType = hand.type
      $('#loaded-content').show()
      $('#loaded-content').animate 'opacity': '1.0', showingDuration

$ ->
  initialize_socket()

  # Clock
  setInterval ->
    $('#clock').html(moment().format('HH:mm:ss'))
  , 1000
