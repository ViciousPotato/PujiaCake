User = require '../models/user'

module.exports = (app) ->
  # Create new address
  app.post '/address', (req, res) ->
    ''