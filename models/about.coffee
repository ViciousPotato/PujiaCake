mongoose = require 'mongoose'

aboutSchema = new mongoose.Schema
  about:  String
  
About = mongoose.model 'About', aboutSchema
module.exports = About