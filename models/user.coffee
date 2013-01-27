mongoose = require 'mongoose'
_        = require 'underscore'

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
  addresses: [ addressSchema ]
}

userSchema.methods.addAddress = (address, callback) ->
  @addresses.push address
  @save (error) ->
    callback error

userSchema.methods.updateAddress = (id, address, callback) ->
  @addresses = @addresses.filter (addr) -> 
    addr._id.toString() isnt id
  @addresses.push address
  @save (error) ->
    callback error
  
userSchema.methods.deleteAddress = (id, callback) ->
  @addresses = @addresses.filter (add) ->
    addr._id.toString() isnt id
  @save (error) ->
    callback error
    
User = mongoose.model 'User', userSchema

module.exports = User
