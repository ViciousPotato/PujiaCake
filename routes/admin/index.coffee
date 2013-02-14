fs = require 'fs'

module.exports = (app) ->
  app.get '/admin/', (req, res) ->
    res.render 'admin_index.jade', active_index: 0 
  
  # Load all js files except index.js in current dir
  fs.readdir __dirname, (error, files) ->
    require("./#{file}")(app) for file in files \
      when file.match(/\.js$/) and file isnt 'index.js'