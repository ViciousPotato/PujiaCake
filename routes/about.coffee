News = require '../models/news'

module.exports = (app) ->
  app.get '/about', (req, res) ->
    res.render 'about.jade'

  app.get '/about/news', (req, res) ->
    News.find {}, (error, news) ->
      return res.render 'error.jade', error: error if error
      res.render 'about_news.jade', news: news