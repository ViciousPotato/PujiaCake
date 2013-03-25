Order  = require '../models/order'
utils  = require '../lib/utils'
config = require '../config'

module.exports = (app) ->
  app.post '/alipay/notify', (req, res) ->
    # required by alipay
    # Verify
    if utils.alipayVerifyNotifier req.body, config.alipay
      order_no = req.body.out_trade_no
      Order.markOrderAsPaid order_no, (error, order) ->
        res.send 'success'
    else
      console.log 'Verify alipay error!'

  app.get '/alipay/return', (req, res) ->
    is_success = req.query.is_success
    order_no = req.query.out_trade_no
    
    return res.redirect '/order/pay_failed' if is_success isnt 'T'
    
    if utils.alipayVerifyNotifier req.query, config.alipay      
      # Mark order_no as paid, and notify the agent.
      Order.markOrderAsPaid order_no, (error, order) ->
        res.redirect '/member/orders'
    else
      return res.render 'error.jade', error: '支付宝来源验证错误'