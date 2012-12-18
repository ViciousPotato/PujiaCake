express = require 'express'
jade = require 'jade'
fs = require 'fs'

mongoose = require 'mongoose'
db = mongoose.createConnection 'localhost', 'test'
# Users
userSchema = mongoose.Schema {email : String, password : String}
User = db.model 'User', userSchema

# Product
productSchema = mongoose.Schema {
	name : String,
	description : String,
	price : String,
	onDiscount : Boolean,
	onGroupon : Boolean,
	image : String,
	kind : String
}
Product = db.model 'Product', productSchema

app = express()

app.use express.bodyParser()
app.use express.cookieParser('secret')
#app.use express.logger()
app.use express.methodOverride()
app.use express.session {secret : 'secret', cookie : {maxAge : 6000}}

app.set 'views', 'views/'
app.set 'view engine', 'jade'
app.set 'view options', {layout : true}

generate_random_code = () ->
	return (parseInt(Math.random() * 10) for i in [1..4]).join("")

# Resource files, images, css, js.
app.get '/', (req, res) ->
	res.sendfile 'index.html'

app.get '/index.html', (req, res) ->
	res.sendfile 'index.html'

app.get '/css/css/:file', (req, res) ->
	res.sendfile 'css/css/' + req.params.file

app.get '/css/img/:file', (req, res) ->
	res.sendfile 'css/img/' + req.params.file

app.get '/js/:file', (req, res) ->
	res.sendfile 'js/' + req.params.file

app.get '/images/:file', (req, res) ->
	res.sendfile 'images/' + req.params.file

app.get '/images/products/:file', (req, res) ->
	res.sendfile 'images/products/' + req.params.file

app.get '/contact/:file', (req, res) ->
	res.sendfile 'contact/' + req.params.file

app.get '/files/:file', (req, res) ->
	res.sendfile 'files/' + req.params.file

app.get '/fonts/:file', (req, res) ->
	res.sendfile 'fonts/' + req.params.file


# About
app.get '/about/:file', (req, res) ->
	res.sendfile 'about/' + req.params.file

# Member functions
app.get '/member/index.html', (req, res) ->
	random_code = generate_random_code()
	res.render 'member_index.jade', {user : req.session['user'], random_code : random_code}

app.get '/member/register', (req, res) ->
	res.render 'member_register.jade'

app.post '/member/register', (req, res) ->
	user = User {email : req.param('email'), password : req.param('password')}
	user.save (err) ->
		res.redirect('member/register_success')

app.get '/member/register_success', (req, res) ->
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
			res.render 'member_login_success.jade'


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
	product = Product {
		name : req.param('product_name'), 
		description : req.param('product_description'), 
		price : req.param('product_price')
	}
	product.save (err) ->
		res.redirect('/admin/')

app.get '/admin/product', (req, res) ->
	Product.find {onDiscount : true}, (discount_err, discount_products) ->
		console.log discount_products
		Product.find {onGroupon : true}, (groupon_err, groupon_products) ->
			console.log groupon_products
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

# Products
app.get '/products/index.html', (req, res) ->
	res.render 'products.jade'

app.get '/products/:kind/index.html', (req, res) ->
	switch req.params.kind
		when 'cakes'
			Product.find {}, (err, products) ->
				res.render 'products_cakes.jade', {products : products, user : req.session['user']}
		when 'chocalates'
			res.render 'products_chocalates.jade'
		when 'candies'
			res.render 'products_candies.jade'
		else
			res.sendfile 'products/' + req.params.kind + '/index.html'

app.listen 3000