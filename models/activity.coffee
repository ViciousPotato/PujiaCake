mongoose = require 'mongoose'

activitySchema = new mongoose.Schema
  activity:  String
  
Activity = mongoose.model 'Activity', activitySchema 
module.exports = Activity