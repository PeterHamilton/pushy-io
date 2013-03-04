auth = require './authenticator'

module.exports = (server, db) ->

  # Attach to a server
  io = require('socket.io').listen(server)

  # Model of our data
  HandModel = db.model 'Hand'

  # Local storage
  queue = []
  chat = []
  HandModel.find {}, (err, hands) ->
    if hands?
      queue = hands.concat queue

  # Number of milliseconds to trigger update
  updateDelay = 10 * 1000
  lastSchedule = Date.now()

  # Unique IDs
  UniqueID = require './model/unique'

  # Client connected
  io.on 'connection', (socket) ->

    # Authenticating client
    socket.on 'login', (credentials, callback) ->
      auth.authenticate credentials, (sessionToken) ->
        console.log sessionToken
        callback sessionToken

    # Registering a new hand
    socket.on 'push', (hand, callback) ->
      username = auth.verify hand.sessionHash
      console.log "From #{hand.sessionHash}, got #{username}"
      if !username?
        callback success: false
        return

      hand.author = username

      #console.log "received " + hand
      if hand.type is 'chat'
        addToChat hand
        socket.broadcast.emit 'chat-data', hand
        callback success: true
      else
        hand.id = new UniqueID
        dbHand = new HandModel hand
        console.log "saving to db"
        dbHand.save (err) ->
          if err?
            console.log "Unable to save " + dbHand
            console.error err
          else
            #console.log "Saved " + dbHand
          callback
            success: !err?
            firstTime: addHand dbHand


  queue.push require './model/csg_notifications'
  queue.push require './model/other_notifications'
  queue.unshift (callback) ->
    callback
      type: 'chat'
      payload:
        messages: chat

  addToChat = (hand) ->
    chat.unshift hand

  addHand = (hand) ->
    queue.splice position + 1, 0, hand
    return +lastSchedule + updateDelay

  pushHand = (hand) ->
    lastSchedule = Date.now()
    io.sockets.emit 'data', hand

  position = 0
  nextHand = ->
    hand = queue[position % queue.length]
    position++
    if hand.till? and hand.till < Date.now()
      HandModel.remove hand, (err) ->
        "Unable to remove " + hand
      queue.splice position - 1, 1
      return nextHand()
    return hand

  pushNextHand = ->
    if queue.length > 0
      hand = nextHand()
      if typeof(hand) is 'function'
        hand (hand) ->
          if hand?
            pushHand hand
          else
            pushNextHand()
      else
        pushHand hand

  pushNextHand()
  setInterval pushNextHand, updateDelay
