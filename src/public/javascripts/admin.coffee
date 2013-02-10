# Server - client communication
handleSockets = ->
  socket = io.connect 'http://localhost:3000'

  #username = prompt "Username:", ""
  username = "Boss"

  currentType = $('#input-type button.active')

  $('#input-type button:not(.disabled)').click ->
    currentType = $(this)
    type = currentType.data 'type'
    initializeTill()
    $('#input-form .input-row').hide()
    $('#input-form .input-row').has("#input-#{type}").show()

  $('#send').click ->
    type = currentType.data 'type'
    input = $("#input-#{type}")
    value = input.val()
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
        when 'chat'
          text: value
    , (success) ->
      if success?
        console.log success
        input.val ''
        $('.successMessage').text "#{currentType.text()} successfully pushed, " +
          if success.firstTime < Date.now()
            "it is being shown."
          else
            "it will be shown at #{printTime success.firstTime}."

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
  $('.datepicker input').val defaultDate
  $('.datepicker').data 'date', defaultDate
  $('.datepicker').datepicker format: 'dd/mm/yyyy'

  # Initialize timepicker
  $('.timepicker').timepicker 'setTime', defaultMoment.format timeFormat

tillTime = ->
  +(moment "#{$('.datepicker input').val()} #{$('.timepicker').val()}",
    "#{dateFormat} #{timeFormat}").toDate()

printTime = (utc) ->
  (moment utc).format "#{timeFormat}, #{dateFormat}"

$ ->
  initializeTill()
  handleSockets()