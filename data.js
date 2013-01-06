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

/*
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

db.users.insert(
	{
		email : 'q@123.com',
		password : '123',
		addresses: [{
		}]
	}
);

db.addresses.insert({
	userId:,
	name : 'Lennon',
	address: '上海市浦东新区张江高科',
	phone: '188164267865',
	zipCode : '201203',
	deliveryMethod: 'express'

});

*/
