module.exports = (callback) ->
  callback
    type: "dashboard"
    author: "doc"
    payload:
      notifications: [
        {
          author: "Peter Hamilton"
          title: "Trial Notifications"
          text: "Mice have bitten through all netwrok cables in labs"
          classes: ['alert-error']
        }
        ,
        {
          author: "Peter Hamilton"
          title: "Trial Notifications"
          text: "Due to LEXIS test all labs will be closed from 1 to 5pm on Tuesday"
          classes: ['alert-info']
        }
      ]
      term: "#ichack"
