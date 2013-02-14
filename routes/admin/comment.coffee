Comment = require '../../models/comment'

module.exports = (app) ->
  # Comments
  app.get '/admin/comments', (req, res) ->
    res.render 'admin_comment.jade'
  
  app.get '/admin/list_comments', (req, res) ->
    Comment.find {}, (error, comments) ->
      res.json comments
      
  app.get '/admin/comment/delete/:commentid', (req, res) ->
    Comment.remove
      _id: req.params.commentid
    , (error) ->
      res.redirect '/admin/comments'
  