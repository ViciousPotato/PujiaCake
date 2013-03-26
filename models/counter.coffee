mongoose = require 'mongoose'

counterSchema = new mongoose.Schema
  name: String
  seq:
    type: Integer
    default: 0

counterSchema.methods.nextOrderSeq = (callback) ->
  this.findOneAndUpdate
    name: 'order'
  , $inc: { seq: 1 }
  , new: true
  , (error, one) ->
    # returns next seq
    callback error, one.seq

Counter = mongoose.model 'Counter', counterSchema 
module.exports = Counter