extends Node


onready var background = $backgorund/background


func _ready():
	
	background.margin_right = Resolution.content_width
	background.margin_bottom = Resolution.content_height
	Game.main = self

	call_deferred( "first_screen" )
	OS.window_maximized = true


var load_state = 0
var cur_scn = ""
func _load_scene( scn ):
	print( "Loading level: ", scn, "   State: ", load_state )
	if load_state == 0:
		# set current scene
		cur_scn = scn
		
		#$gui.black(true)

		#$gui.force_black(true)

		load_state = 1
		$loadtimer.set_wait_time( 1.2 )
		$loadtimer.start()
	elif load_state == 1:
		# hide hud
		#$hud_layer/hud.hide()
		# clear current act
		var children = $screen.get_children()
		if not children.empty():
			#_disconnect_level( children[0] )

			children[0].queue_free()
		load_state = 2
		$loadtimer.set_wait_time( 0.1 )
		$loadtimer.start()
	elif load_state == 2:
		# load new act
		var act = load( cur_scn ).instance()

		$screen.add_child( act )
		
		
		load_state = 3
		$loadtimer.set_wait_time( 0.4 )
		$loadtimer.start()
	elif load_state == 3:
		#$gui.black(false)
		#$gui.force_black(false)


		# play stuff
		print( "finished loading" )
		load_state = 0
	

func _on_loadtimer_timeout():
	_load_scene( cur_scn )


func first_screen():
	_load_scene( "res://gui/screens/start_screen.tscn" )

	#_load_scene( "res://levels/general/entrance.tscn" )
	#_load_scene( "res://levels/general/wolf_station.tscn" )
	#_load_scene( "res://levels/jazz_club/jazz_club.tscn" )

func load_new_scene(path: String):
	_load_scene( path )



