should = require 'should'
utils  = require '../lib/utils'

describe 'Util', ->
  describe '#joinDic', ->
    it 'should do its job', ->
      unorderedDic =
        b: 2
        a: 1
      utils.joinDic(unorderedDic).should.eql 'a=1&b=2'