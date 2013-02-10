module.exports = (server, db) ->

  # Attach to a server
  io = require('socket.io').listen(server)

  # Model of our data
  HandModel = db.model 'Hand'

  # Local storage
  queue = []
  HandModel.find {}, (err, hands) ->
    if hands?
      queue = hands.concat queue

  # Number of milliseconds to trigger update
  updateDelay = 10 * 1000

  # Unique IDs
  UniqueID = require './model/unique'

  # Client connected
  io.on 'connection', (socket) ->

    # Registering a new hand
    socket.on 'push', (hand) ->
      console.log "received " + hand
      hand.id = new UniqueID
      dbHand = new HandModel hand
      dbHand.save (err) ->
        if err?
          console.log "Unable to save " + dbHand
          console.error err
        else
          console.log "Saved " + dbHand
        addHand dbHand

  queue.push require './model/csg_notifications'
  queue.push require './model/other_notifications'

  addHand = (hand) ->
    queue.splice position, 0, hand

  pushHand = (hand) ->
    io.sockets.emit 'data', hand

  position = 0
  nextHand = ->
    hand = queue[position % queue.length]
    position++
    if hand.till? and hand.till < Date.now()
      console.log "we get"

      HandModel.remove hand, (err) ->
        "Unable to remove " + hand
      queue.splice position - 1, 1
      return nextHand()
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
