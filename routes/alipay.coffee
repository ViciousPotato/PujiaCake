Order = require '../models/order'

module.exports = (app) ->
  app.get '/alipay/notify', (req, res) ->
    console.log req
    
  app.post '/alipay/notify', (req, res) ->
    console.log req
    # required by alipay
    res.send 'success'
    
  app.get '/alipay/return', (req, res) ->
    is_success = req.query.is_success
    order_no = req.query.out_trade_no
    
    return res.redirect '/order/pay_failed' if is_success isnt 'T'
    # Mark order_no as paid, and notify the agent.
    Order.markOrderAsPaid order_no, (error, order) ->
      res.redirect '/memeber/orders'