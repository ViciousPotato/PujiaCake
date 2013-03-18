_        = require 'underscore'
mongoose = require 'mongoose'
User     = require '../models/user'
Order    = require '../models/order'
LostPass = require '../models/lostpass'
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
    birthday = new Date(
      req.body.birthday_year, 
      req.body.birthday_month-1,
      req.body.birthday_day)
      
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
        deliveryMethod: req.param('delivery-method'),
        gender:         req.param('gender'),
        birthday:       birthday

    user.save (error) ->
      return res.json 'error': error  if error
      res.render 'member_register_success.jade' 

  app.get '/member/login', (req, res) ->
    random_code = generate_random_code()
    res.render 'member_index.jade', random_code: random_code

  app.get '/member/logout', (req, res) ->
    req.session.user = null
    res.redirect '/member/'
  
  app.post '/member/login', (req, res) ->
    User.findOne
      email:    req.body.email,
      password: req.body.password
    , (error, user) ->
      return res.render 'member_login_failed.jade' if not user
      req.session.user = user
      debug 'user logged in and user is: ', user
      res.render 'member_login_success.jade', user: user # TODO: or should we redirect?

  app.get '/member/orders', (req, res) ->
    Order.find
      userId: req.session.user._id
    , (error, orders) ->
      res.render 'member_orders.jade', orders: orders

  app.get '/member/profile', (req, res) ->
    res.render 'member_profile.jade'
  
  app.post '/member/profile', (req, res) ->
    console.log 'updating ', req.session.user._id
    User.update
      _id: req.session.user._id
    , { 
        $set: {
          gender:   req.body.gender,
          birthday: new Date(
                      req.body.birthday_year,
                      req.body.birthday_month-1,
                      req.body.birthday_day)
        }
      }
    , (error) ->
      console.log arguments
      return res.redirect 'error.jade', error: error if error
      return res.redirect '/member/profile'

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
    
  app.get '/member/lostpass', (req, res) ->
    res.render 'member_lostpass.jade'
    
  app.post '/member/lostpass', (req, res) ->
    code = M
    lostpass = new LostPass
      email: req.body.email
      code: 
  