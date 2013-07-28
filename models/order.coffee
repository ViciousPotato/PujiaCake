_        = require 'underscore'
mongoose = require 'mongoose'

User     = require './user'

orderSchema = new mongoose.Schema
  no:        String, # order number
  time:      { type: Date, default: Date.now },
  products:  mongoose.Schema.Types.Mixed,
  userId:    mongoose.Schema.Types.ObjectId,
  addressId: mongoose.Schema.Types.ObjectId,
  status:    String, # 'confirmed' | 'paid' | 'onexpress' 
  amount:    Number, # totoal amount in this order
  remark:    String  # records which express etc

orderSchema.statics.markOrderAsPaid = (order_no, callback) ->
  Order.update
    no: order_no
  , $set: {status: 'paid'} 
  , (error, order) ->
    return callback error, null if error
    callback null, order

# TODO: refactor routes/admin/order.coffee to share the same common function
orderSchema.statics.getOrderFullInfo = (order_no, callback) ->
  Order.findOne
    no: order_no
  , (error, order) ->
    return callback error, null if error
    User.findOne
      _id: order.userId
    , (error, user) ->
      return callback error, null if error

      address = user.addresses.id order.addressId
      callback null, _.extend order, address: address
    
Order = mongoose.model 'Order', orderSchema
module.exports = Order
