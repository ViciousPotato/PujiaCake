fs = require 'fs'

module.exports = (app) ->
  app.get '/admin/', (req, res) ->
    res.render 'admin_index.jade'
  
  # Load all js files except index.js in current dir
  fs.readdir __dirname, (error, files) ->
    require("./#{file}")(app) for file in files \
      when file.match(/\.coffee$/) and file isnt 'index.coffee'