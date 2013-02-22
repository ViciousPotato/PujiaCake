Chat = require '../models/chat'
_    = require 'underscore'

module.exports = (app) ->
  app.get '/chat/heartbeat', (req, res) ->
    time = req.session.chatLastUpdateTime || Date.now
    user = req.session.chatID
    Chat.getMessages user, time, (error, messages) ->
      return res.json error: error if error
      messages.forEach (message) ->
        message.markAsRead(null)
      # Update time
      req.session.chatLastUpdateTime = Date.now
      return res.json 
        items: messages.map (msg) ->
          { 's': 0, 'f': msg.from, 'm': msg.message }
  
  app.post '/chat/send', (req, res) ->
    from = req.session.chatID
    to   = req.body.to
    message = req.body.message
    chat = new Chat
      from: from
      to: to
      message: message
      read: false
    chat.save (error) ->
      res.render 'error.jade', error: error if error
      res.send '1'
  
  app.get '/chat/start', (req, res) ->
    #TODO: get history item.
    chatID = req.session.chatID
    res.json
      username: chatID
      items: []
    
  app.get '/chat/close', (req, res) ->
    res.send '1'