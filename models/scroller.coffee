mongoose = require 'mongoose'

scrollerSchema = new mongoose.Schema
  title: String
  image: String
  link:  String
  
Scroller = mongoose.model 'Scroller', scrollerSchema 
module.exports = Scroller 