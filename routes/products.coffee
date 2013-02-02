mongoose     = require 'mongoose'
Product      = require '../models/product.js'
IndexProduct = require '../models/index-product.js'
debug        = require('debug')('routes/products')

module.exports = (app) ->
  # Products
  app.get '/products', (req, res) ->
    Product.find {}, (error, products) ->
      return res.render 'error.jade', error: error if error
      res.render 'products.jade', products: products

  app.get '/products/:kind', (req, res) ->
    Product.find
      kind: req.params.kind
    , (error, products) ->
      return res.json error: error if error
      res.render 'products_kind.jade', products: products
  
  app.get '/products/:kind/:id', (req, res) ->
    Product.findOne
      _id: req.params.id
    , (error, product) ->
      return res.render 'error.jade', error: error if error
      res.render 'products_product.jade', product: product

  app.get '/index-products', (req, res) ->
    IndexProduct.find {}, (error, products) ->
      res.json products
  