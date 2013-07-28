(function() {
  var Order, gm, utils;

  gm = require('gm');

  utils = require('../../lib/utils');

  Order = require('../../models/order');

  module.exports = function(app) {
    return app.get('/admin/sheet/:orderid', utils.auth, function(req, res) {
      return Order.findOne({
        no: req.params.order
      }, function(error, order) {
        var sheet_template;
        res.set('Content-Type', 'image/png');
        sheet_template = '../../static/images/selling_sheet.png';
        return gm(sheet_template).stream('png', function(errpr, stdout, stderr) {
          return stdout.pipe(res);
        });
      });
    });
  };

}).call(this);
