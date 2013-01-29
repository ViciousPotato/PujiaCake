$(document).ready(function(){

	// helpful classes
	$('ul li:first-child').addClass('first');
	$('ul li:last-child, ol li:last-child, .breadcrumbs:last, tr:last-child').addClass('last');
	$('tr:even').addClass('even');
	$('tr:odd').addClass('odd');

	// add non semantic markup for fancy background images
	$('body#home div.wrapper.scr').wrap('<div class="ornament_2" />');
	$('div.ornament_2, body:not(#home) footer').wrap('<div class="ornament_footer" />');
	$('body:not(#home) div.ornament_footer').addClass('foot');
	$('div.ornament_footer #copyright').before('<div id="footer-patch"></div>');

	// product scroller
	$('#scrollers ul').quickScroll();
	
	//labelsInInputs
	// $('input[type=text], textarea').labelsInInputs({color: '#54301A', blur_color: '#D8CFC6', left: '36px'});

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
		
		$.ajax({
			url:      '/index-products',
			dataType: 'json',
			success:  function(data) {
		        $.each(data, function(i,item) {
                    if (item.type == 'full') {
                        var htmlz = '';
                        var bg = 'url(' + item.image + '); background-position: 0, 0';
                    } else {
                        var htmlz = '<h3>' + item.name + '</h3><p class="intro">' +
                          item.description + ' <a class="coral" href="' + item.link +
                          '"> <span style="margin-left: 300px;">&#62;</span></a></p>';
                        var bg = 'url(' + item.image + ')';
                    }
                        $('div.wrapper.content').prepend(
                            '<div class="hilite-extra" style="background-image: '+
                            bg+';display:none;">'+htmlz+'</div>');
                    });
                        rotateFrontHilites(1);
            }
        });
	}
});




$(window).resize(function() {
	adjustFooter();
});
