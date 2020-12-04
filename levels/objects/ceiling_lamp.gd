extends StaticBody2D

onready var light = $light
onready var splash = $splash



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func bullet_hit(bullet_type: int, hit_pos: Vector2, normal: Vector2) -> void:
	
	light.enabled = false
	splash.emitting = true
	collision_layer = 0
	
	Game.fx_master.bullet_hit_spark(hit_pos, normal)
