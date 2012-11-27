express = require 'express'
jade = require 'jade'
fs = require 'fs'

mongoose = require 'mongoose'
db = mongoose.createConnection 'localhost', 'test'
# Users
userSchema = mongoose.Schema {email : String, password : String}
User = db.model 'User', userSchema

# Product
productSchema = mongoose.Schema {name : String, description : String, price : String}
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

# Map static files

generate_random_code = () ->
	return '' + parseInt(Math.random() * 10) + parseInt(Math.random() * 10) + parseInt(Math.random() * 10) + parseInt(Math.random() * 10)

app.get '/', (req, res) ->
	res.send 'hello world'

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

app.get '/about/:file', (req, res) ->
	res.sendfile 'about/' + req.params.file

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

app.get '/admin/', (req, res) ->
	res.render 'admin_index.jade', {active_index : 0}

app.get '/admin/list_members', (req, res) ->
	User.find (err, users) ->
		console.log users
		res.render 'admin_list_members.jade', {users : users, active_index : 1}

app.get '/admin/add_product', (req, res) ->
	res.render 'admin_add_product.jade', {active_index : 2}

app.get '/admin/add_index_product', (req, res) ->
	res.render 'admin_add_index_product.jade', {active_index : 3}

app.post '/admin/add_product', (req, res) ->
	product = Product {name : req.param('product_name'), description : req.param('product_description'), price : req.param('product_price')}
	product.save (err) ->
		res.redirect('/admin/')

app.get '/contact/:file', (req, res) ->
	res.sendfile 'contact/' + req.params.file

app.get '/files/:file', (req, res) ->
	res.sendfile 'files/' + req.params.file

app.get '/fonts/:file', (req, res) ->
	res.sendfile 'fonts/' + req.params.file

app.get '/products/index.html', (req, res) ->
	res.sendfile 'products/index.html'

app.get '/products/:kind/index.html', (req, res) ->
	console.log req.params.kind
	if req.params.kind == 'cakes'
		Product.find {}, (err, products) ->
			res.render 'products_cakes.jade', {products : products, user : req.session['user']}
	else
		res.sendfile 'products/' + req.params.kind + '/index.html'

app.listen 3000