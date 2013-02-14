Comment = require '../../models/comment'

module.exports = (app) ->
  # Comments
  app.get '/admin/comments', (req, res) ->
    res.render 'admin_comment.jade', active_index: 6
  
  app.get '/admin/list_comments', (req, res) ->
    Comment.find {}, (error, comments) ->
      res.json comments
      
  app.get '/admin/comment/delete/:commentid', (req, res) ->
    Comment.remove
      _id: req.params.commentid
    , (error) ->
      res.redirect '/admin/comments'
  
  # About
  app.get '/admin/about', (req, res) ->
    About.findOne {}, (error, about) ->
      return res.render 'error.jade', error: error if error
      res.render 'admin_about.jade', 
        about: about?.about, active_index: 7

  app.post '/admin/about', (req, res) ->
    About.remove {}, (error) ->
      # Clean and create
      about = new About
        about: req.body.about
      about.save (error) ->
        res.redirect '/admin/about'
  