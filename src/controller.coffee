module.exports = (server) ->

  # Attach to a server
  io = require('socket.io').listen(server)
  UniqueID = require './model/unique'

  # Local storage
  queue = []

  # Number of milliseconds to trigger update
  updateDelay = 3000

  # Client connected
  io.on 'connection', (socket) ->

    # Registering a new hand
    socket.on 'push', (hand) ->
      console.log "received " + hand
      hand.id = new UniqueID
      queue.splice position, 0, hand

  queue.push require './model/notifications'

  pushHand = (hand) ->
    io.sockets.emit 'data', hand

  position = 0
  nextHand = ->
    hand = queue[position % queue.length]
    position++
    return hand

  pushNextHand = ->
    if queue.length > 0
      hand = nextHand()
      if typeof(hand) == 'function'
        hand (hand) ->
          if hand?
            pushHand hand
          else
            pushNextHand()
      else
        pushHand hand

  setInterval pushNextHand, updateDelay