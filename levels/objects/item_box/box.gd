tool
extends Sprite

export (bool) var update = false setget set_update

func _ready():
	
	pass

func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return

	$"../anims".get_animation("Open").loop = false


