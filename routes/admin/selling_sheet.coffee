gm    = require 'gm'
_     = require 'underscore'
path  = require 'path'
utils = require '../../lib/utils'
Order = require '../../models/order'

module.exports = (app) ->
  app.get '/admin/sheets', utils.auth, (req, res) ->
    res.render 'admin_sheets.jade'

  app.get '/admin/express-sheet/:orderid', (req, res) ->
    Order.getOrderFullInfo req.params.orderid, (error, order) ->
      return res.render 'error.jade', error: error if error

      res.set 'Content-Type', 'image/png'
      sheet_template = 'static/images/sheet_sf.png'
      font = 'static/fonts/simsun.ttc'
      
      # SF sheet size is: 22cm x 14cm
      # sheet_sf.png size is 440x280 px
      address = "#{order.address.province}, #{order.address.city}, #{order.address.address}"
      phone = order.address.phone
      
      sheet = gm(sheet_template)
        .font(font)
        .pointSize(11)
        .drawText(80*2, 84*2, "#{order.address.name}")
        .drawText(25*2, 91*2, address)

      _.each phone, (c, idx) ->
        sheet.drawText(45*2+idx*5*2, 105*2, c)
        
      sheet.stream 'png', (err, stdout, stderr) ->
        stdout.pipe res
          
  app.get '/admin/sheet/:orderid', utils.auth, (req, res) ->
    Order.getOrderFullInfo req.params.orderid, (error, order) ->
      return res.render 'error.jade', error: error if error
      # Or renders image
      res.set 'Content-Type', 'image/png'
      # With paths
      sheet_template = 'static/images/selling_sheet.png'
      font = 'static/fonts/simsun.ttc'
      
      # Write image
      sheet = gm(sheet_template)
        .font(font)
        .pointSize(11)
        .drawText(32, 90, "客户： #{order.address.name}")
        .drawText(32, 105, "地址： #{order.address.province}，#{order.address.city}，#{order.address.address}")
        .drawText(400, 90, "销售日期： #{utils.translateDate(order.time)}")
        .drawText(400, 105, "货单编号： #{order.no}")
      
      # Draw table
      # Draw horizontal lines
      sheet.drawLine 30, 126, 585, 126
      sheet.drawLine 30, 126+27+18*i, 585, 126+27+18*i for i in [0...9]
      # Draw vertical lines
      sheet.drawLine i, 126, i, 296 for i in [30, 75, 459, 537, 585]
      sheet.drawLine i, 126, i, 278 for i in [180, 240, 282, 348, 378, 411]
      # Draw table header
      sheet.drawText(38, 145, "序号")
           .drawText(88, 145, "商品名称")
           .drawText(188, 145, "类别")
           .drawText(248, 145, "品牌")
           .drawText(294, 145, "规格")
           .drawText(353, 145, "单位")
           .drawText(384, 145, "数量")
           .drawText(422, 145, "单价")
           .drawText(474, 145, "总价")
           .drawText(545, 145, "备注")

      productSum = 0
      _.each order.products, (product, index) ->
        # Draw index
        ypos = 166+18*index
        sheet.drawText 38, ypos, "#{index+1}"
        sheet.drawText 82, ypos, "#{product.product.name}"
        sheet.drawText 188, ypos, "#{utils.translateKind(product.product.kind)}"
        sheet.drawText 248, ypos, "莱达林"
        sheet.drawText 294, ypos, "#{product.product.unit}"
        sheet.drawText 353, ypos, "克"
        sheet.drawText 384, ypos, "#{product.quantity}"
        sheet.drawText 422, ypos, "#{product.product.price}"
        sheet.drawText 474, ypos, "#{utils.fixedPrice(product.product.price * product.quantity)}"
        productSum += product.product.price * product.quantity

      # Draw express fee
      expressYPos = 166+18*order.products.length
      sheet.drawText 38, expressYPos, "#{order.products.length+1}"
      sheet.drawText 82, expressYPos, "快递费"
      sheet.drawText 474, expressYPos, "#{utils.fixedPrice(order.amount - productSum)}"

      # Draw sum
      sumYPos = 166+18*7
      sheet.drawText 38, sumYPos, "合计"
      sheet.drawText 474, sumYPos, "#{order.amount}"

      # Draw footer
      sheet.drawText 36, 330, "开单：葛桂兰"
      sheet.drawText 150, 330, "业务员：钱晓平13621685188"
      sheet.drawText 350, 330, "客户签收"
      sheet.drawText 36, 350, "转账信息：上海莱达林实业有限公司 上海银行四平支行316654-00006790170 联系电话：65566594"


      sheet.stream 'png', (err, stdout, stderr) ->
        stdout.pipe res