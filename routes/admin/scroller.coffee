Scroller = require '../../models/scroller'

module.exports = (app) ->
  # Scroller
  app.get '/admin/scroller', (req, res) ->
    res.render 'admin_scroller.jade', active_index: 9
      
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
      res.render 'admin_scroller_edit.jade', 
        active_index: 9, scrollers: scrollers
  
  app.post '/admin/scroller/:id/edit', (req, res) ->
    News.update
      _id: req.params.id
    , $set: { title: req.body.title, content: req.body.content }
    , (error) ->
      res.redirect "/admin/news/#{req.params.id}/edit"
  
  app.get '/admin/scroller/new', (req, res) ->
    res.render 'admin_news_add.jade', active_index: 8
  
  app.post '/admin/scroller/new', (req, res) ->
    news = new News
      title:   req.body.title
      content: req.body.content
    news.save (error) ->
      res.redirect '/admin/news'
  