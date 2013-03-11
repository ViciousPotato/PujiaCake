path = require 'path'

module.exports = (app) ->
  app.get '/admin/uploads/browse', utils.auth, (req, res) ->
    res.send "Browse images"
    
  app.get '/admin/uploads/upload', utils.auth, (req, res) ->
    res.send "Upload images"
    
  app.post '/admin/uploads/upload', utils.auth, (req, res) ->
    url = '/uploads/' + path.basename req.files.upload.path
    funcNum = req.param('CKEditorFuncNum')
    msg = '上传成功'
    res.send "<script type='text/javascript'>window.parent.CKEDITOR.tools.callFunction(#{funcNum}, '#{url}', '#{msg}');</script>"