mongoose = require 'mongoose'

orderSchema = new mongoose.Schema {
  time:      { type: Date, default: Date.now },
  products:  mongoose.Schema.Types.Mixed,
  userId:    mongoose.Schema.Types.ObjectId,
  addressId: mongoose.Schema.Types.ObjectId,
  status:    String, # 'confirmed' | 'paid' | 'onexpress' 
  amount:    Number,
  remark:    String
}

Order = mongoose.model 'Order', orderSchema
module.exports = Order
