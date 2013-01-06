$(document).ready(function(){

	// helpful classes
	$('ul li:first-child').addClass('first');
	$('ul li:last-child, ol li:last-child, .breadcrumbs:last, tr:last-child').addClass('last');
	$('tr:even').addClass('even');
	$('tr:odd').addClass('odd');

	// add non semantic markup for fancy background images
	$('body#home div.wrapper.scr').wrap('<div class="ornament_2" />');
	$('div.ornament_2, body:not(#home) footer').wrap('<div class="ornament_1" />');
	$('body:not(#home) div.ornament_1').addClass('foot');
	$('div.ornament_1 #copyright').before('<div id="footer-patch"></div>');

	// product scroller
	$('#scrollers ul').quickScroll();
	
	//labelsInInputs
	$('input[type=text], textarea').labelsInInputs({color: '#54301A', blur_color: '#D8CFC6', left: '36px'});

	// animate those cute validation bubbles	
	$('form p small').hide().delay(500).slideDown();

	$('.vcard').after('<a href="'+SROOTPATH+'contact/" style="display:block;width:500px;height:320px;position:absolute;top:0px;left:445px;"><!-- omgwtfbbq! --></a>')

	//user feedback messages
	$('div.success, div.info, div.warning').hide().fadeIn(1000);

	$('p#koodoz span').remove();
	$('p#koodoz').html($('p#koodoz').text()).wrapInner('<a href="http://www.koodoz.com.au" target="_blank" />');
	
	$('a[rel*=external]').attr('target','_blank');
	
	// Apply fancybox to multiple items
	// $("a.m").fancybox({ 'width' : 600, 'height' : 600, 'titleShow' : false, 'overlayColor' : '#4B4335', 'overlayOpacity' : 0.87 });

	//remove the border from the previous sibling of a selected nav sidebar item
	$('#sidenav li a.active').parent('li').prev().children('a').css({'background':'none'});
	
	var ollicount=1;
	$('#main ol li').each(function() { $(this).prepend(ollicount); ollicount++; });

	adjustFooter();

	if($('body').attr('id') == 'home') {

		// This code reads from a json page full of data and crossfades the content on the homepage
		/*
		$.ajax({
			url: SROOTPATH + 'fader.php',
			dataType: 'json',
			success: function(data) {
*/
		var data = [
			{
				"id":"6",
				"name":"鸡仔饼",
				"slug":"cupcakes",
				"description":"下午茶，午餐，生日聚会，结婚典礼，公司小吃，濮家饼满足您全方位的需求",
				"page_title":"Cupcakes are perfect for Lunches, Birthdays, Weddings and Baby Showers",
				"extra_text":null,
				"image":"s-chickencake.png"
			},
			{
				"id":"5",
				"name":"兔子饼",
				"slug":"health-cakes",
				"description":"天然无污染，适合老人儿童。",
				"page_title":"Health Cakes &amp; Muffins for a light snack are available in Gluten Free | Health Cakes &amp; Muffins",
				"extra_text":null,
				"image":"s-rabbitcake.png"
			},
			{
				"id":"3",
				"name":"喜饼",
				"slug":"dessert","description":"朋友聚会时为食材发愁？请尝试我们惊心烹制的点心！",
				"page_title":"Dessert Cakes perfect for Dinner Parties and Special Occasions | Dessert Cakes",
				"extra_text":null,
				"image":"s-happycake.png"
			},
			{
				"id":"1",
				"name":"香辣牛肉菓子",
				"slug":"celebration",
				"description":"我们传统的庆祝蛋糕绝对为您的庆祝宴会锦上添花，专业为您提供提供独一无二的大小、颜色以及文字图案。",
				"page_title":"Chocolate Sponge and Mousse Cakes, Mud Cakes and Gateaus | Celebration Cakes",
				"extra_text":"<div class=\"cola\">\r\n<h4>Our Five-Step Ordering Process<\/h4>\r\n<p class=\"intro\">Featuring three layers of airy sponge with a fresh cream centre, they're so easy to order using our simple five-step system.<\/p>\r\n<ol>\r\n<li><span>Choose your cake base - vanilla sponge, chocolate sponge or mud cake<\/span><\/li>\r\n<li><span>Choose your size<\/span><\/li>\r\n<li><span>Choose the colour of your icing<\/span><\/li>\r\n<li><span>Choose your sides - grated chocolate, nougat, flaked almonds or 100s and 1000s<\/span><\/li>\r\n<li><span>Write your special message<\/span><\/li>\r\n<\/ol>\r\n<\/div>\r\n<div class=\"colb\">\r\n<h4>Cake Sizes<\/h4>\r\n<table>\r\n<thead>\r\n<tr>\r\n<th scope=\"col\">Size<\/th>\r\n<th scope=\"col\">Serves<\/th>\r\n<\/tr>\r\n<\/thead>\r\n<tbody>\r\n<tr>\r\n<td>7\" Round<\/td>\r\n<td>6-18<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>7\" Square<\/td>\r\n<td>12-16<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>9\" Round<\/td>\r\n<td>16-20<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>9\" Square<\/td>\r\n<td>20-25<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>11\" Round<\/td>\r\n<td>30-35<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>11\" Square<\/td>\r\n<td>35-40<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>14\" Square<\/td>\r\n<td>40-50<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>16 x 18\"<\/td>\r\n<td>50-80<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>18 x 26\"<\/td>\r\n<td>100+<\/td>\r\n<\/tr>\r\n<\/tbody>\r\n<\/table>\r\n<\/div>\r\n",
				"image":"s-spicybeefcake.png"
			},
			{
				"id":"2",
				"name":"团圆酥",
				"slug":"childrens",
				"description":"完全定制，可爱有趣的蛋糕保证为任何生日的小朋友带来欢乐",
				"page_title":"Birthday Cakes of all designs from Numbers, Dolls, Animals and Themed | Children's Cakes",
				"extra_text":"<div class=\"cola\">\r\n<h4>Our Five-Step Ordering Process<\/h4>\r\n<p class=\"intro\">Follow the five-step process to create the cake of your child's dreams. The final delicious result is limited only to by your imagination, but these are a few of our all time favourites.<\/p>\r\n<ol>\r\n<li><span>Choose your cake base - vanilla sponge, chocolate sponge or mud cake<\/span><\/li>\r\n<li><span>Choose your size<\/span><\/li>\r\n<li><span>Choose the colour of your icing<\/span><\/li>\r\n<li><span>Choose your sides - grated chocolate, nougat, flaked almonds or 100s and 1000s<\/span><\/li>\r\n<li><span>Write your special message<\/span><\/li>\r\n<\/ol>\r\n<\/div>\r\n<div class=\"colb\">\r\n<h4>Cake Sizes<\/h4>\r\n<table>\r\n<thead>\r\n<tr>\r\n<th scope=\"col\">Size<\/th>\r\n<th scope=\"col\">Serves<\/th>\r\n<\/tr>\r\n<\/thead>\r\n<tbody>\r\n<tr>\r\n<td>7\" Round<\/td>\r\n<td>6-18<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>7\" Square<\/td>\r\n<td>12-16<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>9\" Round<\/td>\r\n<td>16-20<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>9\" Square<\/td>\r\n<td>20-25<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>11\" Round<\/td>\r\n<td>30-35<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>11\" Square<\/td>\r\n<td>35-40<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>14\" Square<\/td>\r\n<td>40-50<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>16 x 18\"<\/td>\r\n<td>50-80<\/td>\r\n<\/tr>\r\n<tr>\r\n<td>18 x 26\"<\/td>\r\n<td>100+<\/td>\r\n<\/tr>\r\n<\/tbody>\r\n<\/table>\r\n<\/div>\r\n",
				"image":"s-tuanyuancake.png"
			},
			{
				"id":"4",
				"name":"桃酥",
				"slug":"savouries","description":"精致润滑，口有余香，午后懒散的时光不想来一个么？",
				"page_title":"Our Savoury selection includes Pies, Sausage Rolls, Pasties, Quiches and more | Savouries",
				"extra_text":null,
				"image":"s-peachcake.png"
			},
			{
				"id":"7",
				"name":"福桃",
				"slug":"treats",
				"description":"我们提供的全系列美食，绝对纯天然原料新鲜打造。",
				"page_title":"A delectable selection of Treats including, Biscuits, Meringue, Tarts and more | Treats",
				"extra_text":null,
				"image":"s-agecake.png"
			},
			{
				"id":"8",
				"name":"红豆果子",
				"slug":"catering",
				"description":"不含防腐剂，正宗原料，醇香美味。",
				"page_title":"Freshly-made Sandwich Platters available for Functions and Corporate Catering | Catering",
				"extra_text":null,
				"image":"s-redbeancake.png"
			}
			];
		$.each(data, function(i,item) {
			var htmlz = '<h3>' + item.name + '</h3><p class="intro">'+item.description+' <a class="coral" href="'+SROOTPATH+'products/'+item.slug+'/"> <span style="margin-left: 300px;">&#62;</span></a></p>';
			var bg = 'url(' + SROOTPATH + 'images/' + item.image + ')';
			$('div.wrapper.content').prepend('<div class="hilite-extra" style="background-image: '+bg+';display:none;">'+htmlz+'</div>');
		});
		rotateFrontHilites(1);
//			}
//		});
		
		/*$.getJSON(, function(data) {
			$.each(data, function(i,item) {
				var htmlz = '<h3>' + item.name + '</h3><p class="intro">'+item.description+' <a class="coral" href="'+SROOTPATH+'products/'+item.slug+'/">View our range! <span>&#62;</span></a></p>';
				var bg = 'url(' + SROOTPATH + 'images/' + item.image + ')';
				$('<section class="hilite-extra" />').prependTo($('div.wrapper.content')).html(htmlz).css({'background-image' : bg}).hide();
	
			});
			//rotateFrontHilites(1);
		});
	}*/

	}


	if($('body').attr('id') == 'contact') {
		$('#map').before('<p id="expand"><span>Expand</span></p>');
		initialise_map();
	
		$('#expand').toggle(function() {
			$('#map').animate({height:'500px'}, 'slow', function() {
				initialise_map();
				$('#expand span').text('Contract').addClass('col');
			});
			
		}, function () {
			$('#map').animate({height:'250px'}, 'slow', function() {
				initialise_map();
				$('#expand span').text('Expand').removeClass('col');
			});
		});
	
	};
	

});




$(window).resize(function() {
	adjustFooter();
});