Product = require '../../models/product'

module.exports = (app) ->
  # Products
  app.post '/admin/add_product', (req, res) ->
    product = new Product
      name:        req.param('product_name'), 
      description: req.param('product_description'), 
      price:       req.param('product_price'),
      memberPrice: req.param('product_member_price'),
      unit:        req.param('product_unit'),
      kind:        req.param('product_kind'),
      onDiscount:  if req.param('product_on_discount') then true else false
      onGroupon:   if req.param('product_on_groupon') then true else false,
      image:       '/uploads/' + path.basename req.files.product_image.path

    product.save (error) ->
      res.redirect '/admin/product'

  app.get '/admin/product', (req, res) ->
    res.render 'admin_product.jade'

  app.get '/admin/list_product', (req, res) ->
    Product.find (err, products) ->
      res.json(products)

  app.get '/admin/delete_product/:proudctid', (req, res) ->
    Product.remove
      _id: req.params.proudctid
    , (error) ->
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
  
  
  # Product details.
  app.get '/admin/product/:id/detail', (req, res) ->
    Product.findOne
      _id: req.params.id
    , (error, product) ->
      return res.render 'error.jade', eror: error if error
      res.render 'admin_product_detail.jade', product: product
  
  app.post '/admin/product/:id/detail', (req, res) ->
    Product.update
      _id: req.params.id
    , $set: { detail: req.body.detail } 
    , (error) ->
      return res.render 'error.jade', error: error if error
      res.redirect "/admin/product/#{req.params.id}/detail"  