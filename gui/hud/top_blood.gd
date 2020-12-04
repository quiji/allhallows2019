tool
extends Sprite

export (bool) var update = false setget set_update

func _ready():
	pass # Replace with function body.

func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return


	$"../anims".get_animation("move").loop = false
