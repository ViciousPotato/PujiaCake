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
app.set 'view options', {layout : true}

app.use (req, res, next) ->
  # Use in views
  app.locals.user = req.session.user
  next()

# Index
app.get '/', (req, res) ->
  res.sendfile 'index.html'

app.get '/index.html', (req, res) ->
  res.sendfile 'index.html'

# About
app.get '/about', (req, res) ->
  res.render 'about.jade'

# Guide
app.get '/guide', (req, res) ->
  res.render "guide.jade"

require('./routes/admin.js')(app)
require('./routes/cart.js')(app)
require('./routes/member.js')(app)
require('./routes/products.js')(app)

app.listen 3000