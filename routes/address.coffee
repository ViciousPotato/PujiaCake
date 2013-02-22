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
    User.address.update
    xxx