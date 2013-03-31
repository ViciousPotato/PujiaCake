require 'should'
utils  = require '../lib/utils'
config = require '../config'

describe 'Alipay', ->
  describe '#alipayVerifyNotifier', ->
    it 'should sign correctly', ->
      true
  
    it 'should be able to verify notifier\'s identity', ->
      # Real data
      req =
        body:
          discount: '0.00'
          payment_type: '1'
          subject: '濮家饼交易'
          trade_no: '2013032053422055'
          buyer_email: '13816426955'
          gmt_create: '2013-03-20 23:43:12'
          notify_type: 'trade_status_sync'
          quantity: '1'
          out_trade_no: 'PJB-2013320-3507'
          seller_id: '2088901029881660'
          notify_time: '2013-03-20 23:43:20'
          trade_status: 'TRADE_SUCCESS'
          is_total_fee_adjust: 'N'
          total_fee: '0.10'
          gmt_payment: '2013-03-20 23:43:20'
          seller_email: '13901926392@139.com'
          price: '0.10'
          buyer_id: '2088502901507555'
          notify_id: 'bae2aa36fba0033fab12946a4f89b90105'
          use_coupon: 'N'
          sign_type: 'MD5'
          sign: '2199b93e88d9aefc697d08a7120ef1d9'
        
      conf = config.alipay
      utils.alipayVerifyNotifier(req.body, conf).should.eql true
    
    it 'should be able to recognize fake identify', ->
      utils.alipayVerifyNotifier({}, {}).should.not.eql true
        