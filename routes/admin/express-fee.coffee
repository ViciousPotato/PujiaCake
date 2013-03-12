ExpressFee = require '../../models/express-fee'
utils = require '../../lib/utils'

module.exports = (app) ->
  # Express fees.
  app.get '/admin/express-fee', utils.auth, (req, res) ->
    res.render 'admin_express.jade'

  # @JSON
  app.get '/admin/list_express_fee', utils.auth,  (req, res) ->
    ExpressFee.listFlatten (error, fees) ->
      return res.render 'error.jade', error: error if error
      res.json fees

  app.post '/admin/update_fee', utils.auth, (req, res) ->
    id  = req.param 'pk'
    key = req.param 'name'
    val = req.param 'value'
    
    ExpressFee.updateFlatten id, key, val, (error) ->      
      return res.status(500) if error
      res.json 'status': 'ok'
