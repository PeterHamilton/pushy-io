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

    console.log "sent"
    console.log tillTime()

# Until UI handling
initializeTill = ->
  # Get moment five minutes from now
  defaultMoment = moment().add('minutes', 5)
  dateFormat = 'dd/mm/yyyy'
  timeFormat = 'hh:mm a'

  # Initialize datepicker
  defaultDate = defaultMoment.format 'DD/MM/YYYY'
  $('#datepicker input').val defaultDate
  $('#datepicker').data 'date', defaultDate
  $('#datepicker').datepicker format: dateFormat

  # Initialize timepicker
  $('#timepicker').timepicker 'setTime', defaultMoment.format timeFormat

tillTime = ->
  +(moment "#{$('#datepicker input').val()} #{$('#timepicker').val()}").toDate()

$ ->
  initializeTill()
  handleSockets()