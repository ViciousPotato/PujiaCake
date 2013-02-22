mongoose = require 'mongoose'

chatSchema = new mongoose.Schema
  to:      String
  from:    String
  message: String
  read:    { type: Boolean, default: false }
  time:    { type: String,  default: Date.now }

# Get messages for user since time @time.
chatSchema.statics.getMessages = (user, time, callback) ->
  Chat.find
    to:   user,
    time: { $gt: time }
  , (error, messages) ->
    callback error if error
    callback null, messages

# Get messages sent to customer service
chatSchema.statics.getServiceMessages = (callback) ->
  # All messages sent to '' are service messages
  Chat.find
    to: '',
    read: false
  , (error, messages) ->
    callback error if error
    callback null, messages

# Instance methods.
chatSchema.methods.markAsRead = (callback) ->
  this.update
    read: true
  , (error) ->
    throw error if error

Chat = mongoose.model 'Chat', chatSchema 
module.exports = Chat