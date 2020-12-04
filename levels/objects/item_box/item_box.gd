extends Area2D

signal item_collected

onready var anims = $anims
onready var cue_position = $cue_position

export (int, "Bullet") var item
export (int) var item_type
export (int) var amount

var actor
var box_opened: bool = false

func _ready():
	
		
	connect("body_entered", self, "_on_player_can_open")
	connect("body_exited", self, "_on_player_cannot_open")

	anims.play("Closed") 

func _on_player_can_open(player) -> void:
	player.at_item_box(self)
	Game.level.gui.show_cue(self)

	
func _on_player_cannot_open(player) -> void:
	if not box_opened:
		player.left_item_box()
	else:
		box_opened = false
	Game.level.gui.hide_cue(self)

func open(player):
	Game.level.gui.hide_cue(self)
	anims.play("Open") 
	Game.level.gui.prompt_item(item, item_type, amount)
	yield(Game.level.gui, "item_prompt_finished")
	emit_signal("item_collected")

	match item:
		0:
			GameState.add_bullet_type(item_type, amount)

	monitoring = false


func get_cue_position() -> Vector2:
	return cue_position.get_global_transform_with_canvas().get_origin()
