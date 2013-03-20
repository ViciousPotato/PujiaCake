mongoose  = require 'mongoose'
_         = require 'underscore'
utils     = require '../lib/utils'

# Address
addressSchema = new mongoose.Schema
  name:           String,
  province:       String,
  city:           String,
  address:        String,
  phone:          String,
  zipCode:        String,
  deliveryMethod: String,
  gender:         String,
  birthday:       Date

# Users
userSchema = new mongoose.Schema
  email:     String, 
  password:  String,
  addresses: [ addressSchema ]

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

# Mongoose supplied model validation method is not flexiable enough.
userSchema.methods.validates = (callback) ->
  validator = new utils.Validator
  validator.check(@email, "请输入合法的Email").isEmail()
  validator.check(@password, "密码不能为空").notNull()
  validator.getErrors()

User = mongoose.model 'User', userSchema

# Validations
#User.schema.path('email').required 'true'
#User.schema.path('email').validate (value) ->
#  validator.check(value, '请输入合法的Email').isEmail()


module.exports = User
