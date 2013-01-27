mongoose   = require 'mongoose'
Product    = require '../models/product'
ExpressFee = require '../models/express-fee'
_          = require 'underscore'
debug      = require('debug')('routes/cart')

module.exports = (app) ->
  # Cart
  # Cart storage structure is [
  #   { quantity, product, id },
  # ]
  app.get '/cart/add/:productid', (req, res) ->
    Product.find { _id: req.params.productid }, (err, products) ->
      product = products[0]
      productid = product._id.toString()

      if req.session['cart'] is undefined
        debug("cart is undefined")
        req.session['cart'] = [{ quantity: 1, product: product, id: productid }]
      else
        debug(console.log "cart is defined=" + req.session.cart)
        p = (prod for prod in req.session['cart'] when prod.id is productid)
        if p.length == 0
          #console.log "and we did not find product"
          req.session['cart'].push {quantity : 1, id : productid, product : product}
        else
          p[0].quantity++

      res.render 'cart.jade', { cart: req.session['cart'] }

  app.get '/cart/remove/:productid', (req, res) ->
    newcart = _.map req.session['cart'], (product) ->
      if product.id is req.params.productid
        product.quantity--
      if product.quantity < 0
        product.quantity = 0
      return product
    req.session['cart'] = newcart
    res.render 'cart.jade', { cart: req.session['cart'] }

  app.get '/cart/delete/:productid', (req, res) ->
    req.session['cart'] = (item for item in req.session['cart'] when item.id isnt req.params.productid)
    res.redirect('/cart')

  app.get '/cart', (req, res) ->
    res.render 'cart.jade', {cart : req.session['cart']}

  app.get '/cart/checkout', (req, res) ->
    res.render 'cart_checkout.jade'

  app.post '/cart/confirm-order', (req, res) ->
    cart = req.session.cart
    
    amount_reducer = (sum, product) ->
       product.quantity * product.product.memberPrice + sum
    amount = _.reduce cart, amount_reducer, 0
        
    order = Order {
      products:  req.session['cart'],
      userId:    req.session['user']._id,
      addressId: req.param("address"),
      status:    'paid',
      amount:    amount
    }
    
    order.save (err) ->
      res.redirect '/member/orders'
  
  app.get '/cart/express-fee/:province', (req, res) ->
    # Calculate cart express fee
    cart     = req.session.cart
    user     = req.session.user
    province = req.params.province
    
    debug('calculating express fee to %s', province)
    
    weight = _.reduce cart, (sum, product) ->
      sum + product.quantity * product.weight
    , 0
    
    ExpressFee.find {
      province: province # TODO: what if no address
    }, (error, expressFees) ->
      return res.json { error: error } if error
      
      debug 'Found express fees: ', expressFees
      
      expressFee = _.first expressFees
      
      return res.json {
        sfFee:    expressFee.calculateSFFee(weight),
        otherFee: expressFee.calculateOthersFee(weight) 
      }
  