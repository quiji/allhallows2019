extends Area2D

signal door_entered
signal door_exited

onready var wood_door_open_sfx = $wood_door_open
onready var cue_position = $cue_position

export (NodePath) var target_door_node


var target_door
var actor
var door_opened: bool = false

func _ready():
	
	if target_door_node:
		target_door = get_node(target_door_node)
		
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
	actor = player
	Game.level.gui.connect("screen_closed", self, "_on_screen_blackened")
	Game.level.gui.close_screen()
	door_opened = true
	wood_door_open_sfx.play()

func _on_screen_blackened() -> void:
	
	emit_signal("door_exited")
	target_door.emit_signal("door_entered")
	Game.level.gui.disconnect("screen_closed", self, "_on_screen_blackened")
	actor.position = target_door.global_position

	Game.level.gui.open_screen()
	
func get_cue_position() -> Vector2:
	return cue_position.get_global_transform_with_canvas().get_origin()

	