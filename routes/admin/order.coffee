Order = require '../../models/order'

module.exports = (app) ->
  # Orders
  app.get '/admin/orders', (req, res) ->
    res.render 'admin_orders.jade', {active_index: 4}

  app.get '/admin/list_orders', (req, res) ->
    Order.find {}, (error, orders) ->
      res.json(orders)
  