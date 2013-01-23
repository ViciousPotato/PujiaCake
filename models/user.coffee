mongoose = require 'mongoose'

# Address
addressSchema = new mongoose.Schema {
  name:           String,
  province:       String,
  city:           String,
  address:        String,
  phone:          String,
  zipCode:        String,
  deliveryMethod: String
}
# Users
userSchema = new mongoose.Schema {
  email:     String, 
  password:  String,
  addresses: [addressSchema]
}

module.exports = mongoose.model 'User', userSchema
