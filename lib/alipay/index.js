// Rewrite according to php version
var request = require('request')
  , xml2js  = require('xml2js');

function AliPay(config) {
  this.gateway = 'https://mapi.alipay.com/gateway.do?';
  this.config = config || {};
}

/**
 * 生成签名结果
 * @param para_sort 已排序要签名的数组
 * return 签名结果字符串
 */
AliPay.prototype.buildRequestMysign = function(para_sort) {
  	//把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
  	var prestr = createLinkstring(para_sort);
		
  	var mysign = "";
  	switch (this.config['sign_type'].trim().toUpperCase()) {
  		case "MD5" :
  			mysign = md5Sign(prestr, this.config['key']);
  			break;
  		default :
  			mysign = "";
  	}
		
  	return mysign;
  }  
}

/**
   * 生成要请求给支付宝的参数数组
   * @param para_temp 请求前的参数数组
   * @return 要请求的参数数组
   */
Alipay.prototype.buildRequestPara = function (para_temp) {
	//除去待签名参数数组中的空值和签名参数
	var para_filter = paraFilter(para_temp);

	//对待签名参数数组排序
	var para_sort = argSort(para_filter);

	//生成签名结果
	var mysign = this.buildRequestMysign(para_sort);
		
	//签名结果与签名方式加入请求提交参数组中
	para_sort['sign'] = mysign;
	para_sort['sign_type'] = this.alipay_config['sign_type'].trim().toUpperCase();
		
	return para_sort;
}

/**
   * 生成要请求给支付宝的参数数组
   * @param $para_temp 请求前的参数数组
   * @return 要请求的参数数组字符串
   */
Alipay.prototype.buildRequestParaToString = function (para_temp) {
	//待请求参数数组
	var para = this.buildRequestPara(para_temp);
		
	//把参数组中所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串，并对字符串做urlencode编码
	var request_data = createLinkstringUrlencode(para);
		
	return request_data;
}
	
  /**
   * 建立请求，以表单HTML形式构造（默认）
   * @param $para_temp 请求参数数组
   * @param $method 提交方式。两个值可选：post、get
   * @param $button_name 确认按钮显示文字
   * @return 提交表单HTML文本
   */
Alipay.buildRequestForm = function (para_temp, method, button_name) {
	//待请求参数数组
	var para = this.buildRequestPara(para_temp);
		
	var sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='" + 
              this.gateway + "_input_charset=" + this.config['input_charset'].trim().toUpperCase() +
              "' method='" + method + "'>";
  for (var key in para) {
    var val = para[key];
    sHtml += "<input type='hidden' name='" + key + "' value='" + val + "'/>";
  }              
	//submit按钮控件请不要含有name属性
  sHtml += "<input type='submit' value='" + button_name + "'></form>";
		
	sHtml += "<script>document.forms['alipaysubmit'].submit();</script>";

	return sHtml;
}
	
/**
   * 建立请求，以模拟远程HTTP的POST请求方式构造并获取支付宝的处理结果
   * @param $para_temp 请求参数数组
   * @return 支付宝处理结果
   */
Alipay.prototype.buildRequestHttp = function (para_temp) {
	var sResult = '';
		
	//待请求参数数组字符串
	var request_data = this.buildRequestPara(para_temp);

	//远程获取数据
	var sResult = getHttpResponsePOST(
    this.gateway, 
    this.config['cacert'],
    request_data,
    this.config['input_charset'].trim.toUpper()
  );

	return sResult;
}
	
/**
   * 建立请求，以模拟远程HTTP的POST请求方式构造并获取支付宝的处理结果，带文件上传功能
   * @param para_temp 请求参数数组
   * @param file_para_name 文件类型的参数名
   * @param file_name 文件完整绝对路径
   * @return 支付宝返回处理结果
   */
Alipay.prototype.buildRequestHttpInFile = function(para_temp, file_para_name, file_name) {
	//待请求参数数组
	var para = this.buildRequestPara(para_temp);
	para[file_para_name] = "@" + file_name;
		
	//远程获取数据
	var sResult = getHttpResponsePOST(
    this.gateway, 
    this.config['cacert'],
    para,
    this.config['input_charset'].trim.toUpperCase()
  );

	return sResult;
}
	
/**
   * 用于防钓鱼，调用接口query_timestamp来获取时间戳的处理函数
 * 注意：该功能PHP5环境及以上支持，因此必须服务器、本地电脑中装有支持DOMDocument、SSL的PHP配置环境。建议本地调试时使用PHP开发软件
   * return 时间戳字符串
 */
Alipay.prototype.query_timestamp = function(callback) {
	var url = this.gateway + "service=query_timestamp&partner=" + this.config['partner'].trim().toUpperCase();
	var encrypt_key = "";		
  
  request({
    uri: url
  }, function(error, response, body) {
    // TODO: response.statusCode == 200
    xml2js.parseString(body, function(error, result) {
      callback(null, result.response[0].timestamp[0].encrypt_key[0]);
    })
  });
}

module.exports = AliPay;