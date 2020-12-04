extends Area2D

onready var collision_mask_backup: int = collision_mask
var enabled: bool = false setget set_enabled



func set_enabled(is_it: bool) -> void:
	enabled = is_it
	
	if not enabled:
		collision_mask = 0
	else:
		collision_mask = collision_mask_backup
	
	
