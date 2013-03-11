News = require '../../models/news'
utils = require '../../lib/utils'

module.exports = (app) ->
  app.get '/admin/news', utils.auth, (req, res) ->
    res.render 'admin_news.jade'
      
  app.get '/admin/news/list', utils.auth, (req, res) ->
    News.find {}, (error, news) ->
      res.json news
      
  app.get '/admin/news/:id/delete', utils.auth, (req, res) ->
    News.remove
      _id: req.params.id
    , (error) ->
      res.redirect '/admin/news'
    
  app.get '/admin/news/:id/edit', utils.auth, (req, res) ->
    News.findOne
      _id: req.params.id
    , (error, news) ->
      res.render 'admin_news_edit.jade', news: news
  
  app.post '/admin/news/:id/edit', utils.auth, (req, res) ->
    News.update
      _id: req.params.id
    , $set: { title: req.body.title, content: req.body.content }
    , (error) ->
      res.redirect "/admin/news/#{req.params.id}/edit"
  
  app.get '/admin/news/new', utils.auth, (req, res) ->
    res.render 'admin_news_add.jade'
  
  app.post '/admin/news/new', utils.auth, (req, res) ->
    news = new News
      title:   req.body.title
      content: req.body.content
    news.save (error) ->
      res.redirect '/admin/news'