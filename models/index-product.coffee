mongoose = require 'mongoose'

# Product show on front page.
indexProductSchema = new mongoose.Schema
  name:        String,
  description: String,
  image:       String,
  type:        String,   # type = 'full' | 'withtext'
  link:        String

IndexProduct = mongoose.model 'IndexProduct', indexProductSchema
module.exports = IndexProduct 
