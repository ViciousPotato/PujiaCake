mongoose = require 'mongoose'
_        = require 'underscore'
debug    = require('debug')('models/express-fee')

# Express fees.
expressFeeSchema = new mongoose.Schema {
  province:  String,
  sfFee: {
    basicFee:        { type: Number }, # Yuan
    basicWeight:     { type: Number }, # g
    extraFeeUnit:    { type: Number },
    extraWeightUnit: { type: Number }
  },
  othersFee: {
    basicFee:        { type: Number }, # Yuan
    basicWeight:     { type: Number }, # g
    extraFeeUnit:    { type: Number },
    extraWeightUnit: { type: Number }
  }
}

expressFeeSchema.methods.flatten = () ->
  _id:                       this._id,
  province:                  this.province,
  sfFee_basicFee:            this.sfFee.basicFee,
  sfFee_basicWeight:         this.sfFee.basicWeight,
  sfFee_extraFeeUnit:        this.sfFee.extraFeeUnit,
  sfFee_extraWeightUnit:     this.sfFee.extraWeightUnit,
  othersFee_basicFee:        this.othersFee.basicFee,
  othersFee_basicWeight:     this.othersFee.basicWeight,
  othersFee_extraFeeUnit:    this.othersFee.extraFeeUnit,
  othersFee_extraWeightUnit: this.othersFee.extraWeightUnit

# Returns all flatten express fees
expressFeeSchema.statics.listFlatten = (callback) ->
  this.find {}, (error, fees) ->
    return callback(error) if error
    flatten = _.map fees, (fee) ->
      fee.flatten()
    callback(null, flatten)

expressFeeSchema.statics.updateFlatten = (id, key, val, callback) ->
  key = key.split('_').join '.'
  set = {}
  set[key] = val
  
  debug 'updating with id=%s, key=%s, val=%s', id, key, val
  
  this.update
    _id: id
  , $set: set
  , (error) ->
    return callback(error) if error
    callback(null)

# Calculate sf-express fees for weight weight.
expressFeeSchema.methods.calculateFee = (type, weight) ->
  
  fee = if type is 'sf' then this.sfFee else this.othersFee

  basicWeight     = fee.basicWeight
  basicFee        = fee.basicFee
  extraFeeUnit    = fee.extraFeeUnit 
  extraWeightUnit = fee.extraWeightUnit 

  # If weight is less than basicWeight, use basicFee
  return basicFee if weight <= basicWeight
  
  # If weight is larger, fee is basicFee plus extra fees.
  extraFee = Math.ceil((weight - basicWeight) / extraWeightUnit) * extraFeeUnit
  return basicFee + extraFee

expressFeeSchema.methods.calculateSFFee = (weight) ->
  this.calculateFee 'sf', weight
  
expressFeeSchema.methods.calculateOthersFee = (weight) ->
  this.calculateFee 'others', weight

ExpressFee = mongoose.model 'ExpressFee', expressFeeSchema

module.exports = ExpressFee
