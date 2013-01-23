User = require '../models/user.js'

module.exports = (app) ->
  # Member functions
  app.get '/member', (req, res) ->
    random_code = generate_random_code()
    res.render 'member_index.jade', { random_code: random_code }

  app.get '/member/register', (req, res) ->
    res.render 'member_register.jade'

  app.post '/member/register', (req, res) ->
    user = new User {
      email:    req.param('email'), 
      password: req.param('password'),
      addresses: [{
        name:           req.param('name'),
        address:        req.param('address'),
        phone:          req.param('phone'),
        zipCode:        req.param('zip'),
        deliveryMethod: req.param('delivery-method')
      }]
    }
    user.save (error) ->
      if error
        return res.json({ 'error': error })
      res.render 'member_register_success.jade' 

  app.get '/member/login', (req, res) ->
    random_code = generate_random_code()
    res.render 'member_index.jade', { random_code: random_code }

  app.post '/member/login', (req, res) ->
    User.find {
      email:    req.param('email'),
      password: req.param('password')
    }, (err, users) ->
      if users.length == 0
        res.render 'member_login_failed.jade'
      else
        req.session['user'] = _.first(users)
        res.render 'member_login_success.jade'

  app.get '/member/orders', (req, res) ->
    Order.find {
      userId: req.session['user']._id
    }, (err, orders) ->
      res.render 'member_orders.jade', { orders : orders }

  app.get '/member/profile', (req, res) ->
    res.render 'member_profile.jade'

  app.get '/member/address', (req, res) ->
    res.render 'member_address.jade'

  app.get '/member/orders', (req, res) ->
    Order.find {
      userId: req.session['user']._id
    }, (error, orders) ->
      res.render 'member_orders.jade', { 'orders': orders }

  app.get '/member/score', (req, res) ->
    res.render 'member_score.jade'
  