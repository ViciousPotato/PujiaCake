mongoose = require 'mongoose'

# Express fees.
expressFeeSchema = new mongoose.Schema {
  province:  String,
  sfFee:     Number,
  othersFee: Number,
  unit:      { type: String, default: 'kg' }
}
module.exports = mongoose.model 'ExpressFee', expressFeeSchema
