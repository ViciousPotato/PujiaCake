express  = require 'express'
jade     = require 'jade'
fs       = require 'fs'
_        = require 'underscore'
mongoose = require 'mongoose'
path     = require 'path'

mongoose.connect 'localhost', 'test'

app = express()

app.use express.bodyParser({
  keepExtensions: true,
  uploadDir:      __dirname+'/static/uploads'
})
app.use express.cookieParser('secret')
#app.use express.logger()
app.use express.methodOverride()
app.use express.cookieSession {cookie: {maxAge: 100000000}}
app.use express.static __dirname + '/static'

app.set 'views', 'views/'
app.set 'view engine', 'jade'
app.set 'view options', layout : true, pretty: true

app.use (req, res, next) ->
  random_id = () -> Math.random()
  if not req.session.chatID
    req.session.chatID = req.session.user?.email || random_id()
  # Use in views
  app.locals.user = req.session.user
  app.locals.pretty = true
  next()

# Index
app.get '/', (req, res) ->
  res.sendfile 'index.html'

app.get '/index.html', (req, res) ->
  res.sendfile 'index.html'

# Guide
app.get '/guide', (req, res) ->
  res.render "guide.jade"

require('./routes/admin')(app)
require('./routes/cart')(app)
require('./routes/member')(app)
require('./routes/address')(app)
require('./routes/products')(app)
require('./routes/comment')(app)
require('./routes/about')(app)
require('./routes/chat')(app)
require('./routes/alipay')(app)

app.listen 80
