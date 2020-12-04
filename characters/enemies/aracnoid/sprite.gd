tool
extends Sprite

export (bool) var update = false setget set_update

func _ready():
	
	pass

func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return


	$"../anims".get_animation("StartJump").loop = false
	$"../anims".get_animation("Jump").loop = false
	$"../anims".get_animation("Land").loop = false
	$"../anims".get_animation("JumpPeak").loop = false
	

	