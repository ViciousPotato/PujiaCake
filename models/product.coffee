mongoose = require 'mongoose'

# Product
productSchema = new mongoose.Schema {
  name:        String,
  description: String,
  price:       String,
  memberPrice: Number,
  onDiscount:  Boolean,
  onGroupon:   Boolean,
  image:       String,
  kind:        String,
  unit:        String
}
module.exports = mongoose.model 'Product', productSchema
