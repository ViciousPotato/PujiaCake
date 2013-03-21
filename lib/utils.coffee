crypto     = require 'crypto'
nodemailer = require 'nodemailer'
Validator  = (require 'validator').Validator

# Customize Validator
Validator.prototype.error = (msg) ->
  @_currentError = msg
  @_errors.push(msg)
  return this

Validator.prototype.getCurrentError = () ->
  @_currentError

Validator.prototype.getErrors = () ->
  @_errors

module.exports.Validator = Validator

# Exports other functions
module.exports.auth = (req, res, next) ->
  return res.redirect '/admin/login' if not req.session?.admin?
  return next()

module.exports.randomActivationCode = () ->
  sha1 = crypto.createHash 'sha1'
  randomString = (new Date).toString() + Math.random()
  sha1.update(randomString)
  return sha1.digest('hex')

module.exports.sendPasswordResetMail = (email, code, callback) ->
  smtpTransport = nodemailer.createTransport 'SMTP',
    auth:
      user: 'postmaster@pujiabing.com'
      pass: 'pass'
  mailOptions =
    from: '潽家饼 <postmaster@pujiabing.com>'
    to: email
    subject: '重设密码'
    html: "<a href=\"http://pujiabing.com/member/resetpass?code=#{code}\">重设密码</a>"
  smtpTransport.sendMail mailOptions, (error, response) ->
    return callback error if error
    return callback null

module.exports.alipayVerifyNotifier = (req, conf) ->
  