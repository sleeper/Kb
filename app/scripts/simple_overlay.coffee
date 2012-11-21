class SimpleOverlay
	overlay_cfg=
		"background-color": '#000'
		opacity: '.5'
		position: 'fixed'
		top: 0
		left: 0
		width: '100%' 
		height: '100%'
		display: 'none'

	dialog_cfg=
		"background-color": '#fff'
		"border-radius": '15px'
		border: '1px solid #000'
		padding: '15px'
		position: 'fixed'
		opacity: 1
		display: 'none'		

	constructor: (root)->
		@root = $(root)
		@root.append('<div id="simpleoverlay-overlay">&nbsp;</div>')
		@root.append('<div id="simpleoverlay-dialog"></div>')
		@overlay = $('#simpleoverlay-overlay', @root)
		@dialog = $('#simpleoverlay-dialog', @root)

		# Style the overlay
		@overlay.css overlay_cfg

		# And dialog
		@dialog.css dialog_cfg

	show: ()->
		@overlay.show()
		@dialog.show()
		@center_dialog()

	hide: ()->
		@overlay.hide()
		@dialog.hide()

	toggle: ()->
		@overlay.toggle()
		@dialog.toggle()

	center_dialog: ()->
		width = @dialog.width()
		height = @dialog.height()
		@dialog.css
			position: 'fixed'
			left: ($(window).width() - width) / 2 
			top: ($(window).height() - height) / 2

window.SimpleOverlay = SimpleOverlay
