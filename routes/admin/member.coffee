User = require '../../models/user'

module.exports = (app) ->
  # Members
  app.get '/admin/list_member', (req, res) ->
    User.listFlatten (error, users) ->
      res.json users

  app.get '/admin/member', (req, res) ->
    res.render 'admin_member.jade'
    
  app.get '/admin/member/delete/:memberid', (req, res)->
    User.remove
      _id: req.params.memberid
    , (error) ->
      return res.render 'error.jade', error: error if error
      res.redirect '/admin/member'

  app.post '/admin/update_member', (req, res) ->
    setval = {}
    setval[req.param('name')] = req.param('value')
    User.update
      _id: req.param('pk')
    , $set: setval
    , (error) ->
      return res.json error: error if error
      res.json 'status': 'ok'
  