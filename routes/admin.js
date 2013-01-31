// Generated by CoffeeScript 1.4.0
(function() {
  var Comment, ExpressFee, IndexProduct, Order, Product, User, mongoose, path;

  mongoose = require('mongoose');

  path = require('path');

  User = require('../models/user');

  Product = require('../models/product');

  IndexProduct = require('../models/index-product');

  Order = require('../models/order');

  Comment = require('../models/comment');

  ExpressFee = require('../models/express-fee');

  module.exports = function(app) {
    app.get('/admin/', function(req, res) {
      return res.render('admin_index.jade', {
        active_index: 0
      });
    });
    app.get('/admin/list_member', function(req, res) {
      return User.listFlatten(function(error, users) {
        return res.json(users);
      });
    });
    app.get('/admin/member', function(req, res) {
      return res.render('admin_member.jade', {
        active_index: 1
      });
    });
    app.get('/admin/member/delete/:memberid', function(req, res) {
      return User.remove({
        _id: req.params.memberid
      }, function(error) {
        if (error) {
          return res.render('error.jade', {
            error: error
          });
        }
        return res.redirect('/admin/member');
      });
    });
    app.post('/admin/update_member', function(req, res) {
      var setval;
      setval = {};
      setval[req.param('name')] = req.param('value');
      return User.update({
        _id: req.param('pk')
      }, {
        $set: setval
      }, function(error) {
        if (error) {
          return res.json({
            error: error
          });
        }
        return res.json({
          'status': 'ok'
        });
      });
    });
    app.post('/admin/add_product', function(req, res) {
      var product;
      product = new Product({
        name: req.param('product_name'),
        description: req.param('product_description'),
        price: req.param('product_price'),
        memberPrice: req.param('product_member_price'),
        unit: req.param('product_unit'),
        kind: req.param('product_kind'),
        onDiscount: req.param('product_on_discount') ? true : false,
        onGroupon: req.param('product_on_groupon') ? true : false,
        image: '/uploads/' + path.basename(req.files.product_image.path)
      });
      return product.save(function(error) {
        return res.redirect('/admin/product');
      });
    });
    app.get('/admin/product', function(req, res) {
      return res.render('admin_product.jade', {
        active_index: 2
      });
    });
    app.get('/admin/list_product', function(req, res) {
      return Product.find(function(err, products) {
        return res.json(products);
      });
    });
    app.get('/admin/delete_product/:proudctid', function(req, res) {
      return Product.remove({
        _id: req.params.proudctid
      }, function(error) {
        return res.redirect('/admin/product');
      });
    });
    app.post('/admin/update_product', function(req, res) {
      var key, setval, val;
      setval = {};
      key = req.param("name");
      val = req.param("value");
      if (key === 'onGroupon' || key === 'onDiscount') {
        val = val === '1' ? true : false;
      }
      setval[key] = val;
      return Product.update({
        _id: req.param('pk')
      }, {
        $set: setval
      }, function(err) {
        if (err) {
          res.statusCode = 500;
          return res.send("");
        } else {
          return res.send("ok");
        }
      });
    });
    app.get('/admin/orders', function(req, res) {
      return res.render('admin_orders.jade', {
        active_index: 4
      });
    });
    app.get('/admin/list_orders', function(req, res) {
      return Order.find({
        userId: req.session['user']._id
      }, function(error, orders) {
        return res.json(orders);
      });
    });
    app.get('/admin/index-product', function(req, res) {
      return res.render('admin_index-product.jade', {
        active_index: 3
      });
    });
    app.get('/admin/index-product/delete/:productid', function(req, res) {
      return IndexProduct.remove({
        _id: req.params.productid
      }, function(error) {
        return res.redirect('/admin/index-product');
      });
    });
    app.get('/admin/index-product/list', function(req, res) {
      return IndexProduct.find({}, function(error, products) {
        if (error) {
          return res.json({
            error: error
          });
        }
        return res.json(products);
      });
    });
    app.post('/admin/index-product/update', function(req, res) {
      var key, setval, val;
      key = req.param('name');
      val = req.param('value');
      if (key === 'type') {
        val = val === '1' ? 'full' : 'withtext';
      }
      setval = {};
      setval[key] = val;
      return IndexProduct.update({
        _id: req.param('pk')
      }, {
        $set: setval
      }, function(err) {
        if (err) {
          return res.status(500);
        }
        return res.json({
          'status': 'ok'
        });
      });
    });
    app.post('/admin/index-product', function(req, res) {
      var product;
      product = new IndexProduct({
        name: req.param('product_name'),
        description: req.param('product_description'),
        type: req.param('product_type'),
        link: req.param('product_link'),
        image: '/uploads/' + path.basename(req.files.product_image.path)
      });
      return product.save(function(error) {
        return res.render('admin_index-product.jade', {
          active_index: 3
        });
      });
    });
    app.get('/admin/express-fee', function(req, res) {
      return res.render('admin_express.jade', {
        active_index: 6
      });
    });
    app.get('/admin/list_express_fee', function(req, res) {
      return ExpressFee.listFlatten(function(error, fees) {
        if (error) {
          return res.render('error.jade', {
            error: error
          });
        }
        return res.json(fees);
      });
    });
    app.post('/admin/update_fee', function(req, res) {
      var id, key, val;
      id = req.param('pk');
      key = req.param('name');
      val = req.param('value');
      return ExpressFee.updateFlatten(id, key, val, function(error) {
        if (error) {
          return res.status(500);
        }
        return res.json({
          'status': 'ok'
        });
      });
    });
    app.get('/admin/comments', function(req, res) {
      return res.render('admin_comment.jade', {
        active_index: 5
      });
    });
    app.get('/admin/list_comments', function(req, res) {
      return Comment.find({}, function(error, comments) {
        return res.json(comments);
      });
    });
    return app.get('/admin/comment/delete/:commentid', function(req, res) {
      return Comment.remove({
        _id: req.params.commentid
      }, function(error) {
        return res.redirect('/admin/comments');
      });
    });
  };

}).call(this);
