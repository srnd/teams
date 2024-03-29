// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

Loader = (function(){
	var loader = {
		show: function(){
			$('.loader .check').removeClass('checked');
			$('.loader .error').removeClass('errored');
			$('.loader').fadeIn();
			$('.loader svg').fadeIn();
		},
		done: function(){
			$('.loader svg').fadeOut('fast', function(){
				$('.loader .check').addClass('checked');
				setTimeout(function(){
					$('.loader').fadeOut();
				}, 500);
			});
		},
		error: function(){
			$('.loader svg').fadeOut('fast', function(){
				$('.loader .error').addClass('errored');
				setTimeout(function(){
					$('.loader').fadeOut();
				}, 500);
			});
		}
	};

	return loader;
}());

(function(){
	function ready(){
		// if($('#saveproject').length){
		// 	$('#saveproject').off('click');
		// 	$('#saveproject').click(function(){
		// 		$.ajax({
		// 			url: '/teams/project',
		// 			type: 'POST',
		// 			data: {
		// 				project: {
		// 					name: $('#project').val(),
		// 					description: $('#project_description').val()
		// 				}
		// 			}
		// 		});
		// 	});
		// }

		$("iframe").each(function(){
      $(this).css("height", $(this).width() * 9/16);
    });
	}

	if(window.io){
		var socket = io.connect("wss://codeday-teams-socket.herokuapp.com");

		socket.on('hello', function(){
			console.log('ayy lmao');
		});

		socket.on('eval', function(command){
			eval(command);
		});
	}

	// $(document).ajaxStart(function(){
	// 	Loader.show();
	// });
	//
	// $(document).ajaxSuccess(function(){
	// 	Loader.done();
	// 	swal("", "Saved!", "success");
	// });
	//
	// $(document).ajaxError(function(){
	// 	Loader.error();
	// });

	InstantClick.on('change', ready);
}())
