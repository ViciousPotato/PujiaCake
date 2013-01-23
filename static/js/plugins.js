// remap jQuery to $
(function($){


	$.fn.quickScroll = function(options) {

	var defaults = {
		children: 'li'
	};
	var options = $.extend(defaults, options);

	$(this).each(function(i){

		var o = options;
		var the_left = 0;

		var the_parent = $(this);

		var the_child_width = $(o.children, this).outerWidth(true);
		var the_children_size = $(o.children, this).size();
		var the_parent_width = parseInt($(this).css('width'));
		var the_scroller_width = the_child_width * the_children_size;
		var the_max_offset = the_parent_width - the_scroller_width;

		$(this).css({'position':'relative'}).before('<a class="prev img">Previous</a>').after('<a class="next img">Next</a>').wrapInner('<div class="scroller" />');

		$('div.scroller', this).css({'width': the_scroller_width + 'px','position':'relative'});
		
		$(this).siblings('a.next, a.prev').click(function() {
		
			if($(this).hasClass('next')) {
 				the_left = the_left - the_child_width;
 			if(the_left <= the_max_offset) {
 				the_left = the_max_offset;
 				$(this).addClass('ghosted');
 			}
			$(this).siblings('a.prev').removeClass('ghosted');

	 		} else {
	 			the_left = the_left + the_child_width;
	 			if(the_left >= 0) {
	 				the_left = 0;
	 				$(this).addClass('ghosted');
	 			}
				$(this).siblings('a.next').removeClass('ghosted');
	 		}

			$(this).siblings(the_parent).children('div.scroller').animate({left: the_left}, 'fast');

		});


	});



	};



	$.fn.labelsInInputs = function(options) {
	
		var defaults = {
			top: '7px',
			left: '10px',
			color : '#AAA',
			blur_color: '#DDD',
			font_size : '1.2em'
		};
		var options = $.extend(defaults, options);
	
		//place labels inside inputs
		$(this).parent().css({'position':'relative'});
		$(this).each(function(i){
	
			var o = options;
			var input_id = $(this).attr('id');
			var the_value = $(this).attr('value');
			var the_label = 'label[for='+input_id+']';
			var the_label_text = $(the_label).text();
	
			$(the_label).css({'color' : o.color, 'display' : 'block', 'font-size': o.font_size, 'left' : o.left, 'position' : 'absolute', 'top' : o.top});
	
			if(the_value != '') {
				$(the_label).css({'display' : 'none'});
			}	
		}).focus(function(){
			var o = options;
			var input_id = $(this).attr('id');
			var the_label = 'label[for='+input_id+']';
			var the_label_text = $(the_label).text();
	
			if ($(this).val() == '') {
				$(the_label).css({'color' : o.blur_color});
			}
		}).keyup(function(){
			var input_id = $(this).attr('id');
			var the_label = 'label[for='+input_id+']';
			var the_label_text = $(the_label).text();
	
			if ($(this).val() != '') {
				$(the_label).css({'display' : 'none'});
			}
		}).blur(function(){
			var o = options;	
			var input_id = $(this).attr('id');
			var the_label = 'label[for='+input_id+']';
			var the_label_text = $(the_label).text();
	
			if ($(this).val() == '') {
				$(the_label).css({'color' : o.color, 'display' : 'block'});
			}
	
		});
	}





})(this.jQuery);


function rotateFrontHilites(number) {

	var total = $('.hilite-extra').size();
	
	$('.hilite-extra:nth-child('+number+')').show().delay(6000).fadeOut('slow', function() {
		number++;
		if(number > total) { number = 1; }
		$('.hilite-extra:nth-child('+number+')').fadeIn('slow', function() {
			rotateFrontHilites(number);
		});
	});

}

function adjustFooter() {
	the_ornament = 'div.ornament_1.foot';
	the_ornament_height = $(the_ornament).outerHeight();
	pane_height = $(window).height(); // useable area height
	doc_height = $('html').outerHeight();
	
	the_position = $(the_ornament).css('position');

	if(the_position == 'relative') {
		if(pane_height > doc_height ) {
			$(the_ornament).css({'position':'absolute','bottom':'0','width':'100%','top':'auto'});
		} else {
			$(the_ornament).css({'position':'relative','bottom':'auto','width':'100%','top':'-40px'});
		}
	
	} else {
		if(pane_height > (doc_height + the_ornament_height)) {
			$(the_ornament).css({'position':'absolute','bottom':'0','width':'100%','top':'auto'});
		} else {
			$(the_ornament).css({'position':'relative','bottom':'auto','width':'100%','top':'-40px'});
		}
	
	}
}

// usage: log('inside coolFunc',this,arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console){
    console.log( Array.prototype.slice.call(arguments) );
  }
};
// catch all document.write() calls
(function(doc){
  var write = doc.write;
  doc.write = function(q){ 
    log('document.write(): ',arguments); 
    if (/docwriteregexwhitelist/.test(q)) write.apply(doc,arguments);  
  };
})(document);

//maps
function initialise_map() {
	var latlng = new google.maps.LatLng(-37.913660, 144.993853);
	var info_content = '<p><strong>Keith Cakes</strong><br />46 Church Street, Middle Brighton<br />VIC 3186</p>';
	var myOptions = {
		zoom: 16,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	var map = new google.maps.Map(document.getElementById("map"), myOptions);
	
	var marker = new google.maps.Marker({
		position: latlng,
		title:"Keith Home Made Cakes"
	});
  
	marker.setMap(map);

	var infowindow = new google.maps.InfoWindow({
    	content: info_content
	});

	google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(map,marker);
	});
}