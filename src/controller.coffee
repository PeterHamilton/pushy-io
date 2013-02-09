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

  position = 0
  setInterval ->
    if queue.length > 0
      io.sockets.emit 'data', queue[position % queue.length]
    position++
  , updateDelay