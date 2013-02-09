initialize_socket = ->
  #
  # Server - client communication
  #

  socket = io.connect 'http://localhost:3000'

  socket.on 'data', (hand) ->
    console.log "received"
    console.log hand
    $('#text').html switch hand.type
      when 'dashboard'
        render_dashboard hand.payload
      # when 'text'
      #   hand.payload.message
      # when 'image'
      #   "<img src='#{hand.payload.url}'>"
      # when 'web'
      #   "<iframe width='100%' height='450px' src='#{hand.payload.url}'></image>"
     text.toString()

clone_template = (id) ->
  $("##{id}").clone().attr('id', '')

initialize_twitter_widget = (d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  unless d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//platform.twitter.com/widgets.js"
    fjs.parentNode.insertBefore js, fjs

render_dashboard = (payload) ->
  elem = clone_template 'dashboard-template'
  console.log payload.notifications
  render_notifications payload.notifications, elem
  render_twitter_widget payload.twitter_widget_id, elem
  console.log elem.html()
  $('#main-content').append(elem)

  initialize_twitter_widget document, "script", "twitter-wjs"

render_twitter_widget = (widget_id, elem) ->
  widget_elem = clone_template 'template-twitter-widget'
  widget_elem.attr('data-widget-id', widget_id)
  elem.find('.twitter-widget').html(widget_elem)

render_notifications = (notifications, elem) ->
  elem.find('.notices').html('')
  $(notifications).each (index, notification) ->
    notification_elem = clone_template 'template-notification'

    notification_elem.find('.title').html(notification.title)
    notification_elem.find('.body').html(notification.body)
    elem.find('.notices').append(notification_elem)

$ ->
  data = {
    notifications: [
      {
        title: "This is a title"
        body: "This is a body"
      }
      ,
      {
        title: "This is a title 2"
        body: "This is a body 2"
      }
    ]
    twitter_widget_id: 300189295266893824
  }

  console.log data

  render_dashboard data

  # Clock
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000
