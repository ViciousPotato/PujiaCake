About = require '../../models/about'
utils = require '../../lib/utils'

module.exports = (app) ->
  # About
  app.get '/admin/about', utils.auth, (req, res) ->
    About.findOne {}, (error, about) ->
      return res.render 'error.jade', error: error if error
      res.render 'admin_about.jade', 
        about: about?.about

  app.post '/admin/about', utils.auth, (req, res) ->
    About.remove {}, (error) ->
      # Clean and create
      about = new About
        about: req.body.about
      about.save (error) ->
        res.redirect '/admin/about'