express = require 'express'
jade = require 'jade'
fs = require 'fs'
_ = require 'underscore'
mongoose = require 'mongoose'
path = require 'path'

db = mongoose.createConnection 'localhost', 'test'

# Address
addressSchema = new mongoose.Schema {
	name: String,
	address: String,
	phone: String,
	zipCode: String,
	deliveryMethod: String
}

# Users
userSchema = new mongoose.Schema {
	email: String, 
	password: String,
	# array of address
	addresses: [addressSchema]
}

User = db.model 'User', userSchema

# Product
productSchema = new mongoose.Schema {
	name: String,
	# A short description
	description: String,
	price: String,
	memberPrice: Number,
	onDiscount: Boolean,
	onGroupon: Boolean,
	image: String,
	kind: String,
	unit: String
}

Product = db.model 'Product', productSchema

orderSchema = new mongoose.Schema {
	time: { type: Date, default: Date.now },
	products: mongoose.Schema.Types.Mixed,
	userId: mongoose.Schema.Types.ObjectId,
	addressId: mongoose.Schema.Types.ObjectId,
	status: String,
	amount: Number
}

Order = db.model 'Order', orderSchema

app = express()

app.use express.bodyParser({ keepExtensions: true, uploadDir: __dirname+'/static/uploads' })
app.use express.cookieParser('secret')
#app.use express.logger()
app.use express.methodOverride()
app.use express.cookieSession {cookie: {maxAge: 100000000}}
app.use express.static __dirname + '/static'

app.set 'views', 'views/'
app.set 'view engine', 'jade'
app.set 'view options', {layout : true}

generate_random_code = () ->
	return (parseInt(Math.random() * 10) for i in [1..4]).join("")


app.use (req, res, next) ->
	app.locals.user = req.session.user
	next()

app.get '/', (req, res) ->
	res.sendfile 'index.html'

app.get '/index.html', (req, res) ->
	res.sendfile 'index.html'

# About
app.get '/about', (req, res) ->
	res.render 'about.jade'

# Member functions
app.get '/member', (req, res) ->
	random_code = generate_random_code()
	res.render 'member_index.jade', {user : req.session['user'], random_code : random_code}

app.get '/member/register', (req, res) ->
	res.render 'member_register.jade'

app.post '/member/register', (req, res) ->
	user = new User {
		email: req.param('email'), 
		password: req.param('password'),
		addresses: [{
			name: req.param("name"),
			address: req.param("address"),
			phone: req.param("phone"),
			zipCode: req.param("zip"),
			deliveryMethod: req.param("delivery-method")
		}]
	}
	user.save (error) ->
		if error
			res.json({'error': error})
		res.render 'member_register_success.jade'	

app.get '/member/login', (req, res) ->
	random_code = generate_random_code()
	res.render 'member_index.jade', {user : req.session['user'], random_code : random_code}

app.post '/member/login', (req, res) ->
	User.find {email : req.param('email'), password : req.param('password')}, (err, users) ->
		if users.length == 0
			res.render 'member_login_failed.jade'
		else
			req.session['user'] = users[0]
			res.render 'member_login_success.jade', {user : req.session['user']}

app.get '/member/orders', (req, res) ->
	Order.find {userId: req.session['user']._id}, (err, orders) ->
		res.render 'member_orders.jade', {orders : orders}

app.get '/member/profile', (req, res) ->
	res.render 'member_profile.jade'

app.get '/member/address', (req, res) ->
	User.find {_id: req.session['user']._id}, (err, users) ->
		user = _.first(users)
		res.render 'member_address.jade', {addresses: user.addresses}

app.get '/member/orders', (req, res) ->
	Order.find {userId: req.session['user']._id}, (error, orders) ->
		res.render 'member_orders.jade', {'orders': orders}

app.get '/member/score', (req, res) ->
	res.render 'member_score.jade'

# Admin
app.get '/admin/', (req, res) ->
	res.render 'admin_index.jade', {active_index : 0}
	
app.get '/admin/list_member', (req, res) ->
	User.find (err, users) ->
		res.json(users)

app.get '/admin/member', (req, res) ->
	res.render 'admin_member.jade', {active_index : 1}

app.post '/admin/update_member', (req, res) ->
	setval = {}
	setval[req.param("name")] = req.param("value")
	User.update {_id : req.param('pk')}, {$set : setval}, (err) ->
		if err
		    res.statusCode = 500
		    res.send ""
		else
		    res.send "ok"

app.get '/admin/add_product', (req, res) ->
	res.render 'admin_add_product.jade', {active_index : 2}

app.get '/admin/add_index_product', (req, res) ->
	res.render 'admin_add_index_product.jade', {active_index : 3}

app.post '/admin/add_product', (req, res) ->
	product = new Product {
		name: req.param('product_name'), 
		description: req.param('product_description'), 
		price: req.param('product_price'),
		memberPrice: req.param('product_member_price'),
		unit: req.param('product_unit'),
		kind: req.param('product_kind'),
		onDiscount: if req.param('product_on_discount') then true else false
		onGroupon: if req.param('product_on_groupon') then true else false,
		image: '/uploads/' + path.basename req.files.product_image.path
	}
	product.save (err) ->
		res.redirect '/admin/product'

app.get '/admin/product', (req, res) ->
	Product.find {onDiscount : true}, (discount_err, discount_products) ->
		Product.find {onGroupon : true}, (groupon_err, groupon_products) ->
			res.render 'admin_product.jade', {active_index : 2}

app.get '/admin/list_product', (req, res) ->
	Product.find (err, products) ->
		res.json(products)

app.post '/admin/update_product', (req, res) ->
	setval = {}
	setval[req.param("name")] = req.param("value")
	Product.update {_id : req.param('pk')}, {$set : setval}, (err) ->
		if err
		    res.statusCode = 500
		    res.send ""
		else
		    res.send "ok"

app.get '/admin/orders', (req, res) ->
	res.render 'admin_orders.jade', {active_index: 4}

app.get '/admin/list_orders', (req, res) ->
	Order.find {userId: req.session['user']._id}, (error, orders) ->
		res.json(orders)

# Products
app.get '/products', (req, res) ->
	Product.find {onDiscount : true}, (discount_err, discount_products) ->
		if not discount_err
			Product.find {onGroupon : true}, (groupon_err, groupon_products) ->
				if not groupon_err
					res.render "products.jade", {
						discount_products : discount_products, groupon_products : groupon_products
					}
				else
					res.render "error.jade", {error : groupon_err}
		else
			res.render "error.jade", {error : discount_err}

app.get '/products/:kind', (req, res) ->
	Product.find {kind: req.params.kind}, (error, products) ->
		if error
			res.json {error: error}
		res.render 'products_kind.jade', {products: products}
	
app.get '/products/:kind/:productid', (req, res) ->
	res.render 'products_product.jade'

app.get '/cart/add/:productid', (req, res) ->
	Product.find {_id : req.params.productid}, (err, products) ->
		product = products[0]
		productid = product._id.toString()

		if req.session['cart'] is undefined
			#console.log "cart is undefined"
			req.session['cart'] = [{quantity : 1, product : product, id : productid}]
		else
			#console.log "cart is defined=" + req.session.cart
			p = (prod for prod in req.session['cart'] when prod.id is productid)
			if p.length == 0
				#console.log "and we did not find product"
				req.session['cart'].push {quantity : 1, id : productid, product : product}
			else
				p[0].quantity++

		res.render 'cart.jade', {cart : req.session['cart']}

app.get '/cart/remove/:productid', (req, res) ->
	console.log req.params.productid
	newcart = _.map req.session['cart'], (product) ->
		if product.id is req.params.productid
			product.quantity--
		if product.quantity < 0
			product.quantity = 0
		return product
	req.session['cart'] = newcart
	res.render 'cart.jade', {cart : req.session['cart']}

app.get '/cart/delete/:productid', (req, res) ->
	req.session['cart'] = (item for item in req.session['cart'] when item.id isnt req.params.productid)
	res.redirect('/cart')

app.get '/cart', (req, res) ->
	res.render 'cart.jade', {cart : req.session['cart']}

app.get '/cart/checkout', (req, res) ->
	res.render 'cart_checkout.jade'

app.post '/cart/confirm-order', (req, res) ->
	order = Order {
		products: req.session['cart'],
		userId: req.session['user']._id,
		addressId: req.param("address"),
		status: 'paid',
		amount: _.reduce req.session['cart'], (sum, product) ->
			product.quantity * product.product.memberPrice + sum
		, 0
	}
	order.save (err) ->
		res.redirect '/member/orders'

# Guide
app.get '/guide', (req, res) ->
	res.render "guide.jade"

app.listen 3000