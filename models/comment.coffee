mongoose = require 'mongoose'

commentSchema = new mongoose.Schema
  name:     String
  email:    String
  phone:    String
  enquiry:  String
  
Comment = mongoose.model 'Comment', commentSchema 
module.exports = Comment