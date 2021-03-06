Order = require '../../models/order'
User = require '../../models/user'
_ = require 'underscore'
utils = require '../../lib/utils'

module.exports = (app) ->
  # Orders
  app.get '/admin/orders', utils.auth, (req, res) ->
    res.render 'admin_orders.jade'

  app.get '/admin/list_orders', utils.auth, (req, res) ->
    Order.find {}, (error, orders) ->
      collect = []
      collect_cnt = 0
      _.map orders, (order) ->
        User.findOne
          _id: order.userId
        , (error, user) ->
          address = user.addresses.id(order.addressId)
          collect.push
            products: order.products
            status:   order.status
            _id:      order.no
            amount:   order.amount
            address:  address
            time:     order.time
            remark:   order.remark
            
          collect_cnt++
          if collect_cnt == orders.length
            res.json collect
      if collect_cnt == orders.length
        res.json collect
      
  app.post '/admin/update_order', utils.auth, (req, res) ->
    setval = {}
    setval[req.param('name')] = req.param('value')
    Order.update
      _id: req.param('pk')
    , $set: setval
    , (error) ->
      return res.json error: error if error
      res.json 'status': 'ok'
    
  