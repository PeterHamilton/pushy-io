module.exports = (callback) ->
  request = require 'request'
  cheerio = require 'cheerio'
  request 'https://www.doc.ic.ac.uk/csg-res/dynamic/motd.cgi', (error, response, body) ->

    if !error && response.statusCode == 200
      $ = cheerio.load body
      titles = $('h2')
      names = $('h3')
      ps = $('p')
      notifications = []
      titles.each (i, e) ->
        notifications.push
          title: $(titles[i]).text()
          author: $(names[i]).text()
          text: $(ps[i]).text()
      callback
        type: "dashboard"
        author: "csg"
        payload:
          notifications: notifications
          term: "#ichack"
    else
      callback undefined
