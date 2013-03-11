module.exports.auth = (req, res, next) ->
  return res.redirect '/admin/login' if not req.session?.admin?
  return next()