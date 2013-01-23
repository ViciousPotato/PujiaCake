// Generated by CoffeeScript 1.4.0
(function() {
  var User, generate_random_code, mongoose;

  mongoose = require('mongoose');

  User = require('../models/user.js');

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

  module.exports = function(app) {
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
            province: req.param('province').split(',')[1],
            city: req.param('city').split(',')[1],
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
    return app.get('/member/score', function(req, res) {
      return res.render('member_score.jade');
    });
  };

}).call(this);
