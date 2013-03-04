# Server - client communication
handleSockets = ->
  socket = io.connect() #'http://localhost:3000'

  username = undefined
  sessionHash = undefined

  $('#login-button').click ->
    username = $('#login-value-username').val()
    password = $('#login-value-password').val()
    socket.emit 'login',
      username: username
      password: password
    , (response) ->
      console.log response
      if !response.success
        $.bootstrapGrowl "Username or password incorrect",
          ele: '#login'
          offset:
            from: 'top'
            amount: -40
          type: 'error'
      else
        {sessionHash} = response
        $("#login").data('lightbox').hide()
        showMessage "Welcome #{username}"

  currentType = $('#input-type button.active')

  $('#input-type button:not(.disabled)').click ->
    currentType = $(this)
    type = currentType.data 'type'
    initializeTill()
    $('#input-form .input-row').hide()
    $('#input-form .input-row').has("#input-value-#{type}").show()

  $('input[id^=input-value-]').keypress (e) ->
    if e.which is 13
        $('#input-button').trigger 'click'

  $('#input-button').click ->
    type = currentType.data 'type'
    input = $("#input-value-#{type}")
    value = input.val()
    if value.length > 0
      socket.emit 'push',
        sessionHash: sessionHash
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
      , (result) ->
        if result.success
          input.val ''
          showMessage successMessage currentType, result

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

# User feedback
successMessage = (currentType, success) ->
  "#{currentType.text()} successfully pushed, " +
  if not success.firstTime?
    "Have fun."
  else
    if success.firstTime < Date.now()
      "it is being shown."
    else
      "it will be shown at #{printTime success.firstTime}."

showMessage = (message) ->
  $.bootstrapGrowl message,
    offset:
      from: 'top'
      amount: 80
    type: 'success'

displayClock = ->
  setInterval ->
    $('#clock').html(moment().format('hh:mm:ss a'))
  , 1000


$ ->
  initializeTill()
  handleSockets()
  displayClock()

  $("#login").lightbox backdrop: 'static'


