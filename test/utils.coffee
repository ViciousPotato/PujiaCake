should = require 'should'
utils  = require '../lib/utils'

describe 'Util', ->
  describe '#joinDic', ->
    it 'should do its job', ->
      unorderedDic =
        b: 2
        a: 1
      utils.joinDic(unorderedDic).should.eql 'a=1&b=2'

  describe '#fixedPrice', ->
    it 'should eliminate float error', ->
      utils.fixedPrice(0.1+0.1+0.1).should.eql 0.3
