Product = require '../models/product.js'

module.exports = (app) ->
  # Products
  app.get '/products', (req, res) ->
    Product.find {onDiscount : true}, (discount_err, discount_products) ->
      if not discount_err
        Product.find {onGroupon : true}, (groupon_err, groupon_products) ->
          if not groupon_err
            res.render "products.jade", {
              discount_products: discount_products,
              groupon_products : groupon_products
            }
          else
            res.render "error.jade", {error : groupon_err}
      else
        res.render "error.jade", {error : discount_err}

  app.get '/products/:kind', (req, res) ->
    Product.find {kind: req.params.kind}, (error, products) ->
      if error
        return res.json {error: error}
      res.render 'products_kind.jade', {products: products}
  
  app.get '/products/:kind/:productid', (req, res) ->
    res.render 'products_product.jade'

  app.get '/index-products', (req, res) ->
    IndexProduct.find {}, (error, products) ->
      res.json products
  