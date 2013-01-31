Comment = require '../models/comment'


module.exports = (app) ->
  app.post '/comment', (req, res) ->
    comment = Comment
      name:     req.body.name
      email:    req.body.email
      phone:    req.body.phone
      enquiry:  req.body.enquiry
    
    comment.save (error) ->
      return res.render 'error.jade', error: error if error
      
      res.redirect '/guide'

      
      
    