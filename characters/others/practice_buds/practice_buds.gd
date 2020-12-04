tool
extends StaticBody2D


export (int, "Bottom", "Top") var balloon_type setget set_balloon_type

func _ready():
	
	$anims.get_animation("Hit").loop = false
	$anims.get_animation("HitTop").loop = false

	if balloon_type == 0:
		$anims.play("Idle")
	else:
		$anims.play("IdleTop")



func bullet_hit(bullet_type: int, hit_pos: Vector2, normal: Vector2) -> void:
	
	if balloon_type == 0:
		$anims.play("Hit")
	else:
		$anims.play("HitTop")

	Game.fx_master.bullet_hit_spark(hit_pos, normal)

	collision_layer = 0
	
	
func set_balloon_type(new_type: int):
	balloon_type = new_type
	
	if balloon_type == 0:
		$anims.play("Idle")
	else:
		$anims.play("IdleTop")
	
	
