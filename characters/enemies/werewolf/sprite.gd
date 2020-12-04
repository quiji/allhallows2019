tool
extends Sprite

export (bool) var update = false setget set_update

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return
		
	$"../anims".get_animation("Transform").loop = false
	$"../anims".get_animation("Roar").loop = false
	$"../anims".get_animation("AttackRecovery").loop = false
	$"../anims".get_animation("Attack").loop = false
