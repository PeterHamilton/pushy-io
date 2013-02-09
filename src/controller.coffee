module.exports = (server) ->

  # Attach to a server
  io = require('socket.io').listen(server)

  # Local storage
  clients = [] # name, ...

  # Client connected
  io.sockets.on 'connection', (socket) ->

    # Registering a new player
    socket.on 'wtf', (name) ->
      console.log "#{name} joined"

    # Sent list of online clients
    socket.emit 'clients', "WHAT THE FUCK"