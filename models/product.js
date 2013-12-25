// Generated by CoffeeScript 1.4.0
var Product, mongoose, productSchema;

mongoose = require('mongoose');

productSchema = new mongoose.Schema({
  name: String,
  description: String,
  price: String,
  memberPrice: Number,
  onDiscount: Boolean,
  onGroupon: Boolean,
  image: String,
  kind: String,
  unit: String,
  weight: {
    type: Number,
    "default": 0
  },
  detail: String,
  buyLink: String
});

Product = mongoose.model('Product', productSchema);

module.exports = Product;
