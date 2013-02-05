mongoose = require 'mongoose'

newsSchema = new mongoose.Schema
  title:   String,
  content: String,
  time:    { type: Date, default: Date.now }
  
News = mongoose.model 'News', newsSchema
module.exports = News