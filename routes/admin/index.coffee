fs = require 'fs'
Activity = require '../../models/activity'
utils = require '../../lib/utils'

module.exports = (app) ->
  app.get /^\/admin\/?$/, utils.auth, (req, res) ->
    Activity.find {}, (error, activities) ->
      res.render 'admin_index.jade', activities: activities
  
  # Load all js files except index.js in current dir
  fs.readdir __dirname, (error, files) ->
    require("./#{file}")(app) for file in files \
      when file.match(/\.coffee$/) and file isnt 'index.coffee'