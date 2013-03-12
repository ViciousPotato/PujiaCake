mongoose = require 'mongoose'

orderSchema = new mongoose.Schema {
  no:        String, # order number
  time:      { type: Date, default: Date.now },
  products:  mongoose.Schema.Types.Mixed,
  userId:    mongoose.Schema.Types.ObjectId,
  addressId: mongoose.Schema.Types.ObjectId,
  status:    String, # 'confirmed' | 'paid' | 'onexpress' 
  amount:    Number, # totoal amount in this order
  remark:    String # which express etc
}

orderSchema.statics.markOrderAsPaid = (order_no, callback) ->
  Order.update
    no: order_no
  , $set: {status: 'paid'} 
  , (error, order) ->
    callback error, null if error
    callback null, order
    
Order = mongoose.model 'Order', orderSchema
module.exports = Order
