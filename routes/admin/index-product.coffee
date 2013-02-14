IndexProduct = require '../../models/index-product'

module.exports = (app) ->
  # Index products
  app.get '/admin/index-product', (req, res) ->
    res.render 'admin_index-product.jade', active_index: 3

  app.get '/admin/index-product/delete/:productid', (req, res) ->
    IndexProduct.remove
      _id: req.params.productid
    , (error) ->
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
      res.render 'admin_index-product.jade', active_index: 3
