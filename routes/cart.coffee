mongoose   = require 'mongoose'
Product    = require '../models/product'
ExpressFee = require '../models/express-fee'
Order      = require '../models/order'
_          = require 'underscore'
debug      = require('debug')('routes/cart')

module.exports = (app) ->
  # Cart
  # Cart storage structure is [
  #   { quantity(Number), product, id(String) },
  # ]
  
  # Calculate total amount of cart
  amountCart = (cart) ->
    amount_reducer = (sum, product) ->
       product.quantity * product.product.memberPrice + sum
    return _.reduce cart, amount_reducer, 0
  
  # Calculate total weight of cart
  weightCart = (cart) ->
    _.reduce cart, (sum, item) ->
      sum + item.quantity * item.product.weight
    , 0
  
  app.get '/cart', (req, res) ->
    res.render 'cart.jade', cart: req.session.cart
    
  app.get '/cart/add/:productid', (req, res) ->
    Product.findOne _id: req.params.productid, (error, product) ->
      if product is null and not error
          error = message: '无法找到产品'  
      return res.render 'error.jade', error: error if error
      
      productid = product._id.toString()
      
      req.session.cart = [] if not req.session.cart
      
      # Check if added product existed in cart.
      p = _.find req.session.cart, (p) -> p.id is productid
      if p
        p.quantity++
      else
        req.session.cart.push
          quantity: 1,
          id:       productid,
          product:  product
        
      res.render 'cart.jade', { cart: req.session.cart }

  # Reduce product quantity.
  app.get '/cart/remove/:productid', (req, res) ->
    newcart = _.map req.session.cart, (product) ->
      product.quantity--   if product.id is req.params.productid
      product.quantity = 0 if product.quantity < 0
      product
  
    req.session.cart = newcart
    res.render 'cart.jade', { cart: req.session.cart }

  # Remove product completely.
  app.get '/cart/delete/:productid', (req, res) ->
    productid = req.params.productid
    req.session.cart = 
      _.filter req.session.cart, (item) -> item.id isnt productid
    res.redirect('/cart')

  app.get '/cart/checkout', (req, res) ->
    cart = req.session.cart
    # Calculate express fees for all user addresses.
    provinces = _.map req.session.user.addresses, (address) -> 
      address.province
    
    ExpressFee.find province: { $in: provinces }, (error, fees) ->
      return res.render 'error.jade', { error: error } if error
      weight = weightCart cart
      calcFees = 
        _.map fees, (fee) ->
          province: fee.province
          sfFee:    fee.calculateSFFee(weight)
          otherFee: fee.calculateOthersFee(weight)
      res.render 'cart_checkout.jade',
        amount: amountCart(cart), 
        fees:   calcFees,
        weight: weight

  app.post '/cart/confirm-order', (req, res) ->
    amount = amountCart req.session.cart
        
    order  = Order
      products:  req.session.cart,
      userId:    req.session.user._id,
      addressId: req.body.address,
      status:    'paid',
      amount:    amount
    
    req.session.cart = []
    
    order.save (error) ->
      res.redirect '/member/orders'
  
  app.get '/cart/express-fee/:province', (req, res) ->
    # Calculate cart express fee
    cart     = req.session.cart
    user     = req.session.user
    province = req.params.province
    
    debug 'calculating express fee for %s', province
    debug 'cart is ', cart
    
    weight = _.reduce cart, (sum, item) ->
      sum + item.quantity * item.product.weight
    , 0
    
    debug 'calculating express fee for weight ', weight
    
    ExpressFee.findOne
      province: province # TODO: what if no address
    , (error, expressFee) ->
      return res.json { error: error } if error
      
      debug 'Found express fee: ', expressFee
      
      return res.json
        sfFee:    expressFee.calculateSFFee(weight),
        otherFee: expressFee.calculateOthersFee(weight) 
  