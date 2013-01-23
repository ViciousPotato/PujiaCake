mongoose = require 'mongoose'
Product  = require '../models/product.js'
_        = require 'underscore'

module.exports = (app) ->
  # Cart
  app.get '/cart/add/:productid', (req, res) ->
    Product.find {_id : req.params.productid}, (err, products) ->
      product = products[0]
      productid = product._id.toString()

      if req.session['cart'] is undefined
        #console.log "cart is undefined"
        req.session['cart'] = [{quantity : 1, product : product, id : productid}]
      else
        #console.log "cart is defined=" + req.session.cart
        p = (prod for prod in req.session['cart'] when prod.id is productid)
        if p.length == 0
          #console.log "and we did not find product"
          req.session['cart'].push {quantity : 1, id : productid, product : product}
        else
          p[0].quantity++

      res.render 'cart.jade', {cart : req.session['cart']}

  app.get '/cart/remove/:productid', (req, res) ->
    console.log req.params.productid
    newcart = _.map req.session['cart'], (product) ->
      if product.id is req.params.productid
        product.quantity--
      if product.quantity < 0
        product.quantity = 0
      return product
    req.session['cart'] = newcart
    res.render 'cart.jade', {cart : req.session['cart']}

  app.get '/cart/delete/:productid', (req, res) ->
    req.session['cart'] = (item for item in req.session['cart'] when item.id isnt req.params.productid)
    res.redirect('/cart')

  app.get '/cart', (req, res) ->
    res.render 'cart.jade', {cart : req.session['cart']}

  app.get '/cart/checkout', (req, res) ->
    res.render 'cart_checkout.jade'

  app.post '/cart/confirm-order', (req, res) ->
    order = Order {
      products: req.session['cart'],
      userId: req.session['user']._id,
      addressId: req.param("address"),
      status: 'paid',
      amount: _.reduce req.session['cart'], (sum, product) ->
        product.quantity * product.product.memberPrice + sum
      , 0
    }
    order.save (err) ->
      res.redirect '/member/orders'
  