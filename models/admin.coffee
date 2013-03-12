mongoose = require 'mongoose'

adminSchema = new mongoose.Schema
  name: String,
  pass: String
  
Admin = mongoose.model 'Admin', adminSchema 
module.exports = Admin