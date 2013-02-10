# Server - client communication
handleSockets = ->
  socket = io.connect 'http://localhost:3000'

  #username = prompt "Username:", ""
  username = "Boss"
  $('#input-type button:not(.disabled)').click ->
    type = $(this).data 'type'
    $('#input-form .input-row').hide()
    $('#input-form .input-row').has("#input-#{type}").show()
    $('#send').data 'type', type

  $('#send').click ->
    type = $('#send').data 'type'
    value = $("#input-#{type}").val()
    socket.emit 'push',
      author: username
      type: type
      till: tillTime()
      payload: switch type
        when 'text'
          message: value
        when 'image', 'web'
          url: value
        when 'twitter'
          term: value

    console.log "sent"
    console.log tillTime()

# Until UI handling
dateFormat = 'DD/MM/YYYY'
timeFormat = 'hh:mm a'
initializeTill = ->
  # Get moment five minutes from now
  defaultMoment = moment().add('minutes', 5)

  # Initialize datepicker
  defaultDate = defaultMoment.format dateFormat
  $('#datepicker input').val defaultDate
  $('#datepicker').data 'date', defaultDate
  $('#datepicker').datepicker format: 'dd/mm/yyyy'

  # Initialize timepicker
  $('#timepicker').timepicker 'setTime', defaultMoment.format timeFormat

tillTime = ->
  console.log "#{$('#datepicker input').val()} #{$('#timepicker').val()}"
  +(moment "#{$('#datepicker input').val()} #{$('#timepicker').val()}",
    "#{dateFormat} #{timeFormat}").toDate()

$ ->
  initializeTill()
  handleSockets()