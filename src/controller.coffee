module.exports = (server, db) ->

  # Attach to a server
  io = require('socket.io').listen(server)
  UniqueID = require './model/unique'

  # Local storage
  queue = []

  # Number of milliseconds to trigger update
  updateDelay = 3000

  # Model of our data
  handModel = db.model 'Hand'

  # Client connected
  io.on 'connection', (socket) ->

    # Registering a new hand
    socket.on 'push', (hand) ->
      console.log "received " + hand
      hand.id = new UniqueID
      queue.splice position, 0, hand

      db = new handModel(hand)
      dbHand.save (err) ->
        if err? then console.log "Unable to save " + dbHand; console.error err
        console.log "Saved " + dbHand

  position = 0
  setInterval ->
    if queue.length > 0
      io.sockets.emit 'data', queue[position % queue.length]
    position++
  , updateDelay