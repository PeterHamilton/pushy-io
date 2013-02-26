#
# Module dependencies.
#

express    = require('express')

app = express()

https       = require 'https'
fs          = require 'fs'
path        = require 'path'
mongoose    = require 'mongoose'
db          = require('./db')(mongoose)

app.set 'port', process.env.PORT || 3000 || 443 || 80
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use require('stylus').middleware(__dirname + '/public')
app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'home', 'title': 'Lab Screens'

app.get '/admin', (req, res) ->
  res.render 'admin', 'title': "Admin"

privateKey = fs.readFileSync 'src/auth/server.key'
certificate = fs.readFileSync 'src/auth/server.pem'

server = https.createServer({key: privateKey, cert: certificate}, app).listen app.get('port'), ->
  console.log "Express server listening on port " + app.get('port')

require('./compile')()
require('./controller')(server, db)
