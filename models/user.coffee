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

userSchema.statics.listFlatten = (callback) ->
  this.find {}, (error, users) ->
    return callback error if error
    flatten = _.map users, (user) ->
      user.flatten()
    callback null, flatten

userSchema.methods.flatten = () ->
  _id:      this._id,
  email:    this.email,
  password: this.password

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
