#
# Module dependencies.
#

express    = require('express')
store      = require('./routes/store')
user       = require('./routes/user')
http       = require('http')
path       = require('path')
mongoose   = require 'mongoose'

mongoURL = 'mongodb://mongodb:abMobdims4@ec2-54-228-51-119.eu-west-1.compute.amazonaws.com:27017/'

app = express()

Schema = mongoose.Schema
ObjectId = Schema.ObjectId
mongoose.connection.on 'open', ->
  console.log 'connected to mongo'
mongoose.connection.on 'error', (err) ->
  if err? then throw err
  console.log 'connection eror'
mongoose.connect mongoURL

app.configure ->
  app.set('port', process.env.PORT || 3000 || 80)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(require('stylus').middleware(__dirname + '/public'))
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use(express.errorHandler())

app.get('/', store.home)
app.get('/users', user.list)
app.get '/admin', (req, res) ->
  res.render 'admin', {'title': "Admin"}

server = http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))

require('./controller')(server)
