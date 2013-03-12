Comment = require '../../models/comment'
utils = require '../../lib/utils'

module.exports = (app) ->
  # Comments
  app.get '/admin/comments', utils.auth, (req, res) ->
    res.render 'admin_comment.jade'
  
  app.get '/admin/list_comments', utils.auth, (req, res) ->
    Comment.find {}, (error, comments) ->
      res.json comments
      
  app.get '/admin/comment/delete/:commentid', utils.auth, (req, res) ->
    Comment.remove
      _id: req.params.commentid
    , (error) ->
      res.redirect '/admin/comments'
  