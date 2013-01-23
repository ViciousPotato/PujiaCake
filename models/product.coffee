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
  unit:        String,
  weight:      { type: Number, default: 0 } # weight in g
}
module.exports = mongoose.model 'Product', productSchema
