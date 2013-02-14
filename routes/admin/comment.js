// Generated by CoffeeScript 1.4.0
(function() {
  var Comment;

  Comment = require('../../models/comment');

  module.exports = function(app) {
    app.get('/admin/comments', function(req, res) {
      return res.render('admin_comment.jade');
    });
    app.get('/admin/list_comments', function(req, res) {
      return Comment.find({}, function(error, comments) {
        return res.json(comments);
      });
    });
    return app.get('/admin/comment/delete/:commentid', function(req, res) {
      return Comment.remove({
        _id: req.params.commentid
      }, function(error) {
        return res.redirect('/admin/comments');
      });
    });
  };

}).call(this);
