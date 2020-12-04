extends Control

export (bool) var enabled setget set_enabled
export (int) var bullet_type setget set_bullet_type


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_enabled(is_it: bool) -> void:
	
		
	enabled = is_it
	visible = is_it

func set_bullet_type(new_type: int) -> void:
	
	bullet_type = new_type
	
	$bullet.frame = bullet_type

