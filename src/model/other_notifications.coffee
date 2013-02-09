module.exports = (callback) ->
  callback
    type: "dashboard"
    author: "doc"
    payload:
      notifications: [
        {
          author: "Peter Hamilton"
          title: "Trial Notifications"
          text: "Something BAD"
          classes: ['alert-error']
        }
        ,
        {
          author: "Peter Hamilton"
          title: "Trial Notifications"
          text: "Something Informative"
          classes: ['alert-info']
        }
      ]
      twitter_widget_id: "#ichack"
