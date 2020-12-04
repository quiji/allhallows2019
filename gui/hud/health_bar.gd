extends Control

onready var top_anims = $glass/anims

export (float) var health_ratio = 1.0 setget set_health_ratio

var top_start_pos: Vector2 = Vector2(12, 8)
var top_end_pos: Vector2 = Vector2(12, 89)
var full_length: float = -80.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	top_anims.connect("animation_finished", self, "_on_top_anims_finished")


func set_health_ratio(ratio: float) -> void:

	top_anims.play("move")
	health_ratio = clamp(ratio, 0.0, 1.0)
	
	$glass/top_blood.position = top_start_pos.linear_interpolate(top_end_pos, 1.0 - health_ratio)
	$middle.scale.y = lerp(0.0, full_length, health_ratio)
	

func _on_top_anims_finished(anim_name: String) -> void:
	
	if anim_name == "move":
		top_anims.play("Still")
		
