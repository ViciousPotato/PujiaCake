module.exports = (app) ->
  app.get '/alipay/notify', (req, res) ->
    console.log req