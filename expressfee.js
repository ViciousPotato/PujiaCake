db.expressfees.remove();
var provinces = [
  "北京市", "天津市", "上海市", "重庆市", "河北省", 
  "山西省", "台湾省", "辽宁省", "吉林省", "黑龙江省",
  "江苏省", "浙江省", "安徽省", "福建省", "江西省", 
  "山东省", "河南省", "湖北省", "湖南省", "广东省", 
  "甘肃省", "四川省", "贵州省", "海南省", "云南省", 
  "青海省", "陕西省", "广西壮族自治区", "西藏自治区", 
  "宁夏回族自治区", "其它"
];

var provinceFees = [
  {
    province: province,
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500        
    }
  },
];

provinces.forEach(function(province) {
    db.expressfees.insert({
        province: province,
        sfFee: {
            basicFee:        5.0,
            basicWeight:     500,
            extraFeeUnit:    2.0,
            extraWeightUnit: 500
        },
        othersFee: {
            basicFee:        5.0,
            basicWeight:     500,
            extraFeeUnit:    2.0,
            extraWeightUnit: 500        
        }
    });    
});

/*
db.products.remove()
db.products.insert(
	{
		name : '圆边巧克力蛋糕', description : '圆边的蛋糕', 
		price : 200, memberPrice : 150,
		onDiscount : true, onGroupon : false, 
		image : '/images/Round-sponge-chocolate-smarties-cake-175.jpg',
		kind : 'cakes',
		unit: '250g'
	}
);
db.products.insert(
	{
		name : '花心蛋糕', description : '测试数据', 
		price : 100, memberPrice : 80,
		onDiscount : true, onGroupon : true, 
		image : '/images/Square-Sponge-Floral-Cake-171.jpg',
		kind : 'cakes',
		unit: '250g'
	}
);
db.products.insert(
	{
		name : '坚果蛋糕', description : '坚果蛋糕，纯天然材料', 
		price : 12.5, memberPrice : 10,
		onDiscount : true, onGroupon : true, 
		image : '/images/Square-Sponge-Fruit-Nuts-Cake-172.jpg',
		kind : 'cakes',
		unit: '250g'
	}
);
db.products.insert(
	{
		name : '褔桃', description : '褔桃，老人儿童皆适宜', 
		price : 11, memberPrice : 8,
		onDiscount : false, onGroupon : false, 
		image : '/images/Square-Sponge-Fruit-Nuts-Cake-172.jpg',
		kind : 'cakes',
		unit: '250g'
	}
);


db.users.remove();
db.users.insert(
	{
		email: '123@126.com',
		password: '123',
		addresses: [{
			name: 'Martin',
			address: '上海市浦东新区张江高科',
			phone: '138164267865',
			zipCode: '201203',
			deliveryMethod: 'sf'
		}]
	}
);

db.users.insert(
	{
		email : 'hurry@hotmail.com',
		password : '123',
		addresses: [{
			name : '李毅',
			address : '安徽省蚌埠市',
			phone : '1672312313211',
			zipCode : '201203',
			deliveryMethod: 'express'
		}]
	}
);
*/