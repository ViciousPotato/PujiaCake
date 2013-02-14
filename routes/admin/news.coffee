News = require '../../models/news'

module.exports = (app) ->
  app.get '/admin/news', (req, res) ->
    res.render 'admin_news.jade', active_index: 8
      
  app.get '/admin/news/list', (req, res) ->
    News.find {}, (error, news) ->
      res.json news
      
  app.get '/admin/news/:id/delete', (req, res) ->
    News.remove
      _id: req.params.id
    , (error) ->
      res.redirect '/admin/news'
    
  app.get '/admin/news/:id/edit', (req, res) ->
    News.findOne
      _id: req.params.id
    , (error, news) ->
      res.render 'admin_news_edit.jade', 
        active_index: 8, news: news
  
  app.post '/admin/news/:id/edit', (req, res) ->
    News.update
      _id: req.params.id
    , $set: { title: req.body.title, content: req.body.content }
    , (error) ->
      res.redirect "/admin/news/#{req.params.id}/edit"
  
  app.get '/admin/news/new', (req, res) ->
    res.render 'admin_news_add.jade', active_index: 8
  
  app.post '/admin/news/new', (req, res) ->
    news = new News
      title:   req.body.title
      content: req.body.content
    news.save (error) ->
      res.redirect '/admin/news'