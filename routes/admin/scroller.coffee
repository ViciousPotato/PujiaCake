path     = require 'path'
Scroller = require '../../models/scroller'

module.exports = (app) ->
  # Scroller
  app.get '/admin/scroller', (req, res) ->
    res.render 'admin_scroller.jade'
  
  # Don't auth this. Index page requires this page.
  app.get '/admin/scroller/list', (req, res) ->
    Scroller.find {}, (error, scrollers) ->
      res.json scrollers
      
  app.get '/admin/scroller/:id/delete', (req, res) ->
    Scroller.remove
      _id: req.params.id
    , (error) ->
      res.redirect '/admin/scroller'
    
  app.get '/admin/scroller/:id/edit', (req, res) ->
    Scroller.findOne
      _id: req.params.id
    , (error, scrollers) ->
      res.render 'admin_scroller_edit.jade', scrollers: scrollers
  
  app.post '/admin/scroller/:id/edit', (req, res) ->
    Scroller.update
      _id: req.params.id
    , $set: { title: req.body.title, content: req.body.content }
    , (error) ->
      res.redirect "/admin/news/#{req.params.id}/edit"
  
  app.get '/admin/scroller/new', (req, res) ->
    res.render 'admin_news_add.jade'
  
  app.post '/admin/scroller/new', (req, res) ->
    scroller = new Scroller
      title: req.body.scroller_title
      link:  req.body.scroller_link
      image: '/uploads/' + path.basename req.files.scroller_image.path
    scroller.save (error) ->
      res.redirect '/admin/scroller'
  