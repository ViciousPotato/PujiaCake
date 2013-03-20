mongoose = require 'mongoose'

lostpassSchema = new mongoose.Schema
  email: String,
  code: String
  invalidateTime: Date
  
LostPass = mongoose.model 'LostPass', lostpassSchema 
module.exports = LostPass