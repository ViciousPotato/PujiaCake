_        = require 'underscore'
mongoose = require 'mongoose'
User     = require '../models/user'
Order    = require '../models/order'
debug    = (require 'debug')('routes/member')


generate_random_code = ->
  return (parseInt(Math.random() * 10) for i in [1..4]).join("")

module.exports = (app) ->
  # utils funcs
  
  extractAddr = (req) ->
    address = 
      name:           req.body.name
      province:       req.body.province        
      city:           req.body.city
      address:        req.body.address
      phone:          req.body.phone
      zipCode:        req.body.zipCode
      deliveryMethod: req.body.deliveryMethod    
    return address
  
  currentUser = (callback) ->
    User.find
      _id: req.session.user._id
    , (error, users) ->
      callback error, error or _.first users
  
  listOrderProduct = (order) ->
    ''
  
  # Member functions
  app.get '/member', (req, res) ->
    random_code = generate_random_code()
    res.render 'member_index.jade', { random_code: random_code }

  app.get '/member/register', (req, res) ->
    res.render 'member_register.jade'

  app.post '/member/register', (req, res) ->
    user = new User
      email:     req.param('email'), 
      password:  req.param('password'),
      addresses:
        name:           req.param('name'),
        province:       req.param('province').split(',')[1],
        city:           req.param('city').split(',')[1],
        address:        req.param('address'),
        phone:          req.param('phone'),
        zipCode:        req.param('zip'),
        deliveryMethod: req.param('delivery-method')

    user.save (error) ->
      return res.json 'error': error  if error
      res.render 'member_register_success.jade' 

  app.get '/member/login', (req, res) ->
    random_code = generate_random_code()
    res.render 'member_index.jade', random_code: random_code

  app.post '/member/login', (req, res) ->
    User.find
      email:    req.param('email'),
      password: req.param('password')
    , (error, users) ->
      return res.render 'member_login_failed.jade' if users.length is 0
      req.session.user = _.first users
      debug 'user logged in and user is: ', req.session.user
      res.render 'member_login_success.jade' # TODO: or should we redirect?

  app.get '/member/orders', (req, res) ->
    Order.find
      userId: req.session.user._id
    , (error, orders) ->
      res.render 'member_orders.jade', orders: orders

  app.get '/member/profile', (req, res) ->
    res.render 'member_profile.jade'

  # Address related: list, create, edit, delete
  app.get '/member/address', (req, res) ->
    # The address is already in user's session.
    res.render 'member_address.jade'
  
  # Create new address
  app.post '/member/address', (req, res) ->
    User.findOne
      _id: req.session.user._id
    , (error, user) ->
      address = extractAddr req
      
      user.addresses.push address
      user.save (error) ->
        return res.render 'error.jade', error: error if error
        res.redirect '/member/address' 
  
  # Update address
  app.put '/member/address', (req, res) ->
    User.findOne
      _id: req.session.user._id
    , (error, user) ->
      address = extractAddr req
      user.updateAddress req.body.id, address, (error) ->
        return res.json error: error if error
        res.json success: 'success'
        
  # Delete address
  app.delete '/member/address', (req, res) ->
    currentUser (error, user) ->
      return res.json { error: error } if error
      user.addresses.id(req.body.id).remove()
      user.save (error) ->
        return res.json error: error if error
        res.json success: 'success'

  app.get '/member/orders', (req, res) ->
    Order.find
      userId: req.session.user._id
    , (error, orders) ->
      res.render 'member_orders.jade', 'orders': orders

  app.get '/member/score', (req, res) ->
    res.render 'member_score.jade'
  