User = require '../models/user'
_    = require 'underscore'

module.exports = (app) ->
  # Edit address
  app.get '/member/address/:id/edit', (req, res) ->
    address = _.filter req.session.user.addresses, (address) ->
      address._id is req.params.id
    address = _.first address
    res.render 'member_address_edit.jade', address: address
  
  app.post '/member/address/:id', (req, res) ->
    # We can't use req.session.user for user because it's simple a dict.
    # We have to use User methods to get user object with methods.
    User.findOne
      _id: req.session.user._id
      , (error, user) ->
        return res.render 'error.jade', error: error if error
        address = user.addresses.id req.params.id
        address.name           = req.param('name')
        address.province       = req.param('province').split(',')[1]
        address.city           = req.param('city').split(',')[1]
        address.address        = req.param('address')
        address.phone          = req.param('phone')
        address.zipCode        = req.param('zip')
        address.deliveryMethod = req.param('delivery-method')
        user.save (error, user) ->
          return res.render 'error.jade', error: error if error
          # Update user in session
          req.session.user = user
          return res.redirect "/member/address\##{_.last(user.addresses)._id}"
          
  # Delete address
  app.get '/member/address/:id/delete', (req, res) ->
    address = _.filter req.session.user.addresses, (address) ->
      address._id is req.params.id
    address = _.first address
    User.findOne
      _id: req.session.user._id
    , (error, user) ->
      user.addresses.id(address._id).remove()
      user.save (error, user) ->
        req.session.user = user
        return res.redirect '/member/address'
  