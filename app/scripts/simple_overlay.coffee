window.SimpleOverlay = window.SimpleOverlay || {}

class SimpleOverlay
	constructor: (root)->
		@root = $(root)
		@root.append('<div id="simpleoverlay-overlay">&nbsp;</div>')
		@root.append('<div id="simpleoverlay-dilog">&nbsp;</div>')
		@overlay = $('#simpleoverlay-overlay', @root)
		@dialog = $('#simpleoverlay-dialog', @root)

		# Style the overlay
		@overlay.css {
			# "background-color": '#000',
   			opacity: '.5',
   			position: 'fixed',
   			top: 0,
   			left: 0,
   			width: '100%', 
   			height: '100%',
   			display: 'none'
		}

   		# And dialog
   		@dialog.css {
   			"background-color": '#fff',
  			"border-radius": '15px',
  			border: '1px solid #000',
  			padding: '15px',
  			position: 'fixed',
  			opacity: 0,
  			display: 'none',
  			}

  	center_dialog: ()->
  		width = @dialog.width()
  		height = @dialog.height()
  		@dialog.css
  		    position: 'fixed',
          	left: ($(window).width() - width) / 2 
          	top: ($(window).height() - height) / 2
