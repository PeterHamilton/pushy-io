module.exports = (server) ->

  # Attach to a server
  io = require('socket.io').listen(server)

  # Local storage
  queue = []
  changed = false

  # Number of milliseconds to trigger update
  updateDelay = 3000

  # Client connected
  io.on 'connection', (socket) ->

    # Registering a new hand
    socket.on 'push', (hand) ->
      console.log "received " + hand
      queue.unshift hand
      changed = true

  setInterval ->
    if changed
      io.sockets.emit 'data', queue[0]
      changed = false
  , updateDelay