Admin = require '../../models/admin'

module.exports = (app) ->
  app.get '/admin/login', (req, res) ->
    res.render 'admin_login.jade'
  
  app.post '/admin/login', (req, res) ->
    Admin.findOne
      name: req.body.name
      pass: req.body.pass
    , (error, admin) ->
      return res.render 'error.jade', error: error if error
      return res.render 'error.jade', error: '用户名密码错误' if not admin
      req.session.admin = admin
      res.redirect '/admin/'
      
  app.get '/admin/logout', (req, res) ->
    req.session.admin = null
    res.redirect '/admin/'
      