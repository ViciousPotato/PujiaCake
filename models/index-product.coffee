mongoose = require 'mongoose'

# Product show on front page.
indexProductSchema = new mongoose.Schema {
  name:        String,
  description: String,
  image:       String,
  # type = 'full' | 'withtext' to decide how to display on front page.
  type:        String,
  link:        String
}
module.exports = mongoose.model 'IndexProduct', indexProductSchema
