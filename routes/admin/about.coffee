About = require '../../models/about'

module.exports = (app) ->
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