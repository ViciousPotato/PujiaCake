Chat = require '../../models/chat'

module.exports = (app) ->
  app.get '/admin/chat', (req, res) ->
    # Init
    Chat.getServiceMessages (error, messages) ->
      return res.render 'error.jade', error: error if error
      return res.render 'admin_chat.jade', messages: messages
  
  app.get '/admin/chat/heartbeat', (req, res) ->
    # Send newest messages to customer service
    ''
    
  app.get '/admin/chat/markasread', (req, res) ->
    # After sending the message to customer service,
    # the messages are not guranteened to be read.
    # All messages read must be sent to this method.
    ''