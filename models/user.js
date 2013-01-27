// Generated by CoffeeScript 1.4.0
(function() {
  var User, addressSchema, mongoose, userSchema, _;

  mongoose = require('mongoose');

  _ = require('underscore');

  addressSchema = new mongoose.Schema({
    name: String,
    province: String,
    city: String,
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

  userSchema.methods.addAddress = function(address, callback) {
    this.addresses.push(address);
    return this.save(function(error) {
      return callback(error);
    });
  };

  userSchema.methods.updateAddress = function(id, address, callback) {
    this.addresses = this.addresses.filter(function(addr) {
      return addr._id.toString() !== id;
    });
    this.addresses.push(address);
    return this.save(function(error) {
      return callback(error);
    });
  };

  userSchema.methods.deleteAddress = function(id, callback) {
    this.addresses = this.addresses.filter(function(add) {
      return addr._id.toString() !== id;
    });
    return this.save(function(error) {
      return callback(error);
    });
  };

  User = mongoose.model('User', userSchema);

  module.exports = User;

}).call(this);
