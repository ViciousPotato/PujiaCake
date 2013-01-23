// Generated by CoffeeScript 1.4.0
(function() {
  var mongoose, orderSchema;

  mongoose = require('mongoose');

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

  module.exports = mongoose.model('Order', orderSchema);

}).call(this);