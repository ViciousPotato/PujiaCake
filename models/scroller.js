// Generated by CoffeeScript 1.4.0
(function() {
  var Scroller, mongoose, scrollerSchema;

  mongoose = require('mongoose');

  scrollerSchema = new mongoose.Schema({
    title: String,
    image: String,
    link: String
  });

  Scroller = mongoose.model('Scroller', scrollerSchema);

  module.exports = Scroller;

}).call(this);
