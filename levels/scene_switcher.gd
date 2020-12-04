extends Area2D


onready var cue_position = $cue_position

export (String, FILE) var target_scene


var target_door
var actor
var door_opened: bool = false

func _ready():
	
	connect("body_entered", self, "_on_player_can_open")
	connect("body_exited", self, "_on_player_cannot_open")

func _on_player_can_open(player) -> void:
	player.at_door(self)
	Game.level.gui.show_cue(self)

	
func _on_player_cannot_open(player) -> void:
	if not door_opened:
		player.left_door()
	else:
		door_opened = false
	Game.level.gui.hide_cue(self)


func enter(player):
	Game.level.gui.hide_cue(self)
	actor = player
	Game.level.gui.connect("screen_closed", self, "_on_screen_blackened")
	Game.level.gui.close_screen()
	door_opened = true


func _on_screen_blackened() -> void:
	
	
	Game.level.gui.disconnect("screen_closed", self, "_on_screen_blackened")

	Maestro.fade_out()
	Game.main.load_new_scene(target_scene)
	

func get_cue_position() -> Vector2:
	return cue_position.get_global_transform_with_canvas().get_origin()
