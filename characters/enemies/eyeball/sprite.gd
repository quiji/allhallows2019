tool
extends Sprite

export (bool) var update = false setget set_update
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return


	$"../anims".get_animation("spotted").loop = false