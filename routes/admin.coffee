mongoose     = require 'mongoose'
path         = require 'path'
User         = require '../models/user'
Product      = require '../models/product'
IndexProduct = require '../models/index-product'
Order        = require '../models/order'
Comment      = require '../models/comment'
ExpressFee   = require '../models/express-fee'

module.exports = (app) ->
  # Admin
  app.get '/admin/', (req, res) ->
    res.render 'admin_index.jade', { active_index: 0 }
  
  app.get '/admin/list_member', (req, res) ->
    User.find (error, users) ->
      res.json(users)

  app.get '/admin/member', (req, res) ->
    res.render 'admin_member.jade', { active_index: 1 }

  app.post '/admin/update_member', (req, res) ->
    setval = {}
    setval[req.param('name')] = req.param('value')
    User.update {
      _id: req.param('pk')
    }, { $set: setval }, (error) ->
      if error
        return res.json { error: error }
      res.json { 'status': 'ok' }

  app.post '/admin/add_product', (req, res) ->
    product = new Product {
      name:        req.param('product_name'), 
      description: req.param('product_description'), 
      price:       req.param('product_price'),
      memberPrice: req.param('product_member_price'),
      unit:        req.param('product_unit'),
      kind:        req.param('product_kind'),
      onDiscount:  if req.param('product_on_discount') then true else false
      onGroupon:   if req.param('product_on_groupon') then true else false,
      image:       '/uploads/' + path.basename req.files.product_image.path
    }
    product.save (error) ->
      res.redirect '/admin/product'

  app.get '/admin/product', (req, res) ->
    res.render 'admin_product.jade', { active_index: 2 }

  app.get '/admin/list_product', (req, res) ->
    Product.find (err, products) ->
      res.json(products)

  app.get '/admin/delete_product/:proudctid', (req, res) ->
    Product.remove {
      _id: req.params.proudctid
    }, (error) ->
      res.redirect '/admin/product'

  app.post '/admin/update_product', (req, res) ->
    setval = {}
    key = req.param("name")
    val = req.param("value")
    if key is 'onGroupon' or key is 'onDiscount'
      val = if val is '1' then true else false

    setval[key] = val
    Product.update {_id : req.param('pk')}, {$set : setval}, (err) ->
      if err
          res.statusCode = 500
          res.send ""
      else
          res.send "ok"

  app.get '/admin/orders', (req, res) ->
    res.render 'admin_orders.jade', {active_index: 4}

  app.get '/admin/list_orders', (req, res) ->
    Order.find {userId: req.session['user']._id}, (error, orders) ->
      res.json(orders)

  # Index products
  app.get '/admin/index-product', (req, res) ->
    res.render 'admin_index-product.jade', { active_index: 3 }

  app.get '/admin/index-product/delete/:productid', (req, res) ->
    IndexProduct.remove {
      _id: req.params.productid
    }, (error) ->
      res.redirect '/admin/index-product'

  app.get '/admin/index-product/list', (req, res) ->
    IndexProduct.find {}, (error, products) ->
      if error
        return res.json {error: error}
      res.json(products)

  app.post '/admin/index-product/update', (req, res) ->
    key = req.param 'name'
    val = req.param 'value'
    if key is 'type'
      val = if val is '1' then 'full' else 'withtext'

    setval = {}
    setval[key] = val
    
    IndexProduct.update {_id: req.param('pk')}, {$set: setval}, (err) ->
      return res.status 500 if err
      res.json({'status': 'ok'})

  app.post '/admin/index-product', (req, res) ->
    product = new IndexProduct
      name:        req.param('product_name'),
      description: req.param('product_description'),
      type:        req.param('product_type'),
      link:        req.param('product_link'),
      image:       '/uploads/' + path.basename req.files.product_image.path
      
    product.save (error) ->
      res.render 'admin_index-product.jade', { active_index: 3 }
  
  # Express fees.
  app.get '/admin/express-fee', (req, res) ->
    res.render 'admin_express.jade', active_index: 6

  app.get '/admin/list_express_fee', (req, res) ->
    ExpressFee.listFlatten (error, fees) ->
      return res.render 'error.jade', error: error if error
      res.json fees

  app.post '/admin/update_fee', (req, res) ->
    id  = req.param 'pk'
    key = req.param 'name'
    val = req.param 'value'
    
    ExpressFee.updateFlatten id, key, val, (error) ->      
      return res.status(500) if error
      res.json 'status': 'ok'
  
  # Comments
  app.get '/admin/comments', (req, res) ->
    res.render 'admin_comment.jade', active_index: 5
  
  app.get '/admin/list_comments', (req, res) ->
    Comment.find {}, (error, comments) ->
      res.json comments
      
  app.get '/admin/comment/delete/:commentid', (req, res) ->
    Comment.remove
      _id: req.params.commentid
    , (error) ->
      res.redirect '/admin/comments'
  