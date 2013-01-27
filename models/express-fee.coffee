mongoose = require 'mongoose'

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
