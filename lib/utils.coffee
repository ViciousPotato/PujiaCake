crypto     = require 'crypto'
nodemailer = require 'nodemailer'
Validator  = (require 'validator').Validator
_          = require 'underscore'

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
  # req is a hash, not req in express
  joinDic = module.exports.joinDic
  dic = _.omit req, ['sign', 'sign_type']
  str = "#{joinDic dic}#{conf.key}"

  md5 = crypto.createHash 'md5'
  md5.update str, conf.input_charset
  hex = md5.digest 'hex'

  return req.sign == hex

module.exports.joinDic = (dic) ->
  # with order
  # {'b': 1, 'a': 2}
  # ->
  # a=2&b=1
  orderedKeys = _.keys(dic).sort()
  orderedKeyVals = _.map orderedKeys, (k) ->
    "#{k}=#{dic[k]}"
  orderedKeyVals.join '&'

module.exports.fixedPrice = (price) ->
  Math.round(price * 100) / 100

module.exports.translateKind = (kind) ->
  table =
    'candies': '糖果'
    'cakes': '糕点'
    'chocalates': '巧克力'

  return table[kind]

module.exports.translateDate = (date) ->
  #[year, month, day] = date.split('T')[0].split('-')
  "#{date.getFullYear()}年#{date.getMonth()+1}月#{date.getDate()}日"

  