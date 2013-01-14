// Generated by CoffeeScript 1.4.0
(function() {
  var IndexProduct, Order, Product, User, addressSchema, app, db, express, fs, generate_random_code, indexProductSchema, jade, mongoose, orderSchema, path, productSchema, userSchema, _;

  express = require('express');

  jade = require('jade');

  fs = require('fs');

  _ = require('underscore');

  mongoose = require('mongoose');

  path = require('path');

  db = mongoose.createConnection('localhost', 'test');

  addressSchema = new mongoose.Schema({
    name: String,
    address: String,
    phone: String,
    zipCode: String,
    deliveryMethod: String
  });

  userSchema = new mongoose.Schema({
    email: String,
    password: String,
    addresses: [addressSchema]
  });

  User = db.model('User', userSchema);

  productSchema = new mongoose.Schema({
    name: String,
    description: String,
    price: String,
    memberPrice: Number,
    onDiscount: Boolean,
    onGroupon: Boolean,
    image: String,
    kind: String,
    unit: String
  });

  Product = db.model('Product', productSchema);

  indexProductSchema = new mongoose.Schema({
    name: String,
    description: String,
    image: String,
    type: String,
    link: String
  });

  IndexProduct = db.model('IndexProduct', indexProductSchema);

  orderSchema = new mongoose.Schema({
    time: {
      type: Date,
      "default": Date.now
    },
    products: mongoose.Schema.Types.Mixed,
    userId: mongoose.Schema.Types.ObjectId,
    addressId: mongoose.Schema.Types.ObjectId,
    status: String,
    amount: Number
  });

  Order = db.model('Order', orderSchema);

  app = express();

  app.use(express.bodyParser({
    keepExtensions: true,
    uploadDir: __dirname + '/static/uploads'
  }));

  app.use(express.cookieParser('secret'));

  app.use(express.methodOverride());

  app.use(express.cookieSession({
    cookie: {
      maxAge: 100000000
    }
  }));

  app.use(express["static"](__dirname + '/static'));

  app.set('views', 'views/');

  app.set('view engine', 'jade');

  app.set('view options', {
    layout: true
  });

  generate_random_code = function() {
    var i;
    return ((function() {
      var _i, _results;
      _results = [];
      for (i = _i = 1; _i <= 4; i = ++_i) {
        _results.push(parseInt(Math.random() * 10));
      }
      return _results;
    })()).join("");
  };

  app.use(function(req, res, next) {
    app.locals.user = req.session.user;
    return next();
  });

  app.get('/', function(req, res) {
    return res.sendfile('index.html');
  });

  app.get('/index.html', function(req, res) {
    return res.sendfile('index.html');
  });

  app.get('/about', function(req, res) {
    return res.render('about.jade');
  });

  app.get('/member', function(req, res) {
    var random_code;
    random_code = generate_random_code();
    return res.render('member_index.jade', {
      random_code: random_code
    });
  });

  app.get('/member/register', function(req, res) {
    return res.render('member_register.jade');
  });

  app.post('/member/register', function(req, res) {
    var user;
    user = new User({
      email: req.param('email'),
      password: req.param('password'),
      addresses: [
        {
          name: req.param('name'),
          address: req.param('address'),
          phone: req.param('phone'),
          zipCode: req.param('zip'),
          deliveryMethod: req.param('delivery-method')
        }
      ]
    });
    return user.save(function(error) {
      if (error) {
        return res.json({
          'error': error
        });
      }
      return res.render('member_register_success.jade');
    });
  });

  app.get('/member/login', function(req, res) {
    var random_code;
    random_code = generate_random_code();
    return res.render('member_index.jade', {
      random_code: random_code
    });
  });

  app.post('/member/login', function(req, res) {
    return User.find({
      email: req.param('email'),
      password: req.param('password')
    }, function(err, users) {
      if (users.length === 0) {
        return res.render('member_login_failed.jade');
      } else {
        req.session['user'] = _.first(users);
        return res.render('member_login_success.jade');
      }
    });
  });

  app.get('/member/orders', function(req, res) {
    return Order.find({
      userId: req.session['user']._id
    }, function(err, orders) {
      return res.render('member_orders.jade', {
        orders: orders
      });
    });
  });

  app.get('/member/profile', function(req, res) {
    return res.render('member_profile.jade');
  });

  app.get('/member/address', function(req, res) {
    return res.render('member_address.jade');
  });

  app.get('/member/orders', function(req, res) {
    return Order.find({
      userId: req.session['user']._id
    }, function(error, orders) {
      return res.render('member_orders.jade', {
        'orders': orders
      });
    });
  });

  app.get('/member/score', function(req, res) {
    return res.render('member_score.jade');
  });

  app.get('/admin/', function(req, res) {
    return res.render('admin_index.jade', {
      active_index: 0
    });
  });

  app.get('/admin/list_member', function(req, res) {
    return User.find(function(error, users) {
      return res.json(users);
    });
  });

  app.get('/admin/member', function(req, res) {
    return res.render('admin_member.jade', {
      active_index: 1
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

  app.get('/admin/messages', function(req, res) {
    return res.send('not implemented');
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

  app.get('/admin/index-product/update', function(req, res) {
    var key, setval, val;
    setval = {};
    key = req.param('name');
    val = req.param('value');
    if (key === 'type') {
      val = val === '1' ? 'full' : 'withtext';
    }
    setval[key] = val;
    return IndexProduct.update({
      _id: req.param('pk')
    }, {
      $set: setval
    }, function(err) {
      if (err) {
        res.statusCode = 500;
        return res.send("");
      } else {
        return res.json({
          'status': 'ok'
        });
      }
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

  app.get('/products', function(req, res) {
    return Product.find({
      onDiscount: true
    }, function(discount_err, discount_products) {
      if (!discount_err) {
        return Product.find({
          onGroupon: true
        }, function(groupon_err, groupon_products) {
          if (!groupon_err) {
            return res.render("products.jade", {
              discount_products: discount_products,
              groupon_products: groupon_products
            });
          } else {
            return res.render("error.jade", {
              error: groupon_err
            });
          }
        });
      } else {
        return res.render("error.jade", {
          error: discount_err
        });
      }
    });
  });

  app.get('/products/:kind', function(req, res) {
    return Product.find({
      kind: req.params.kind
    }, function(error, products) {
      if (error) {
        return res.json({
          error: error
        });
      }
      return res.render('products_kind.jade', {
        products: products
      });
    });
  });

  app.get('/products/:kind/:productid', function(req, res) {
    return res.render('products_product.jade');
  });

  app.get('/index-products', function(req, res) {
    return IndexProduct.find({}, function(error, products) {
      return res.json(products);
    });
  });

  app.get('/cart/add/:productid', function(req, res) {
    return Product.find({
      _id: req.params.productid
    }, function(err, products) {
      var p, prod, product, productid;
      product = products[0];
      productid = product._id.toString();
      if (req.session['cart'] === void 0) {
        req.session['cart'] = [
          {
            quantity: 1,
            product: product,
            id: productid
          }
        ];
      } else {
        p = (function() {
          var _i, _len, _ref, _results;
          _ref = req.session['cart'];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            prod = _ref[_i];
            if (prod.id === productid) {
              _results.push(prod);
            }
          }
          return _results;
        })();
        if (p.length === 0) {
          req.session['cart'].push({
            quantity: 1,
            id: productid,
            product: product
          });
        } else {
          p[0].quantity++;
        }
      }
      return res.render('cart.jade', {
        cart: req.session['cart']
      });
    });
  });

  app.get('/cart/remove/:productid', function(req, res) {
    var newcart;
    console.log(req.params.productid);
    newcart = _.map(req.session['cart'], function(product) {
      if (product.id === req.params.productid) {
        product.quantity--;
      }
      if (product.quantity < 0) {
        product.quantity = 0;
      }
      return product;
    });
    req.session['cart'] = newcart;
    return res.render('cart.jade', {
      cart: req.session['cart']
    });
  });

  app.get('/cart/delete/:productid', function(req, res) {
    var item;
    req.session['cart'] = (function() {
      var _i, _len, _ref, _results;
      _ref = req.session['cart'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (item.id !== req.params.productid) {
          _results.push(item);
        }
      }
      return _results;
    })();
    return res.redirect('/cart');
  });

  app.get('/cart', function(req, res) {
    return res.render('cart.jade', {
      cart: req.session['cart']
    });
  });

  app.get('/cart/checkout', function(req, res) {
    return res.render('cart_checkout.jade');
  });

  app.post('/cart/confirm-order', function(req, res) {
    var order;
    order = Order({
      products: req.session['cart'],
      userId: req.session['user']._id,
      addressId: req.param("address"),
      status: 'paid',
      amount: _.reduce(req.session['cart'], function(sum, product) {
        return product.quantity * product.product.memberPrice + sum;
      }, 0)
    });
    return order.save(function(err) {
      return res.redirect('/member/orders');
    });
  });

  app.get('/guide', function(req, res) {
    return res.render("guide.jade");
  });

  app.listen(3000);

}).call(this);
