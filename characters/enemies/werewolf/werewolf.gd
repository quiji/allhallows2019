extends KinematicBody2D

signal wolf_death

onready var states = $states
onready var anims = $anims
onready var sprite : Sprite = $sprite
onready var talk_position = $talk_position
onready var bite_area = $bite_area
onready var howl_sfx = $howl_sfx
onready var bite_sfx= $wolf_bite
onready var wolf_transform = $wolf_transform



#export (float) var health = 40.0
export (float) var health = 80.0
export (float) var bite_damage = 6.0
export (float) var touch_damage = 1.0
#export (float) var run_speed = 270.0
export (float) var run_speed = 320.0
export (int) var actions_count_before_roar = 4
export (bool) var likes_to_talk = false
export (bool) var enabled = true setget set_enabled
var player_target = null

var direction: Vector2
var actions_for_roar: int = 0
var is_player_bitable: bool = false

func _ready():

	add_to_group("player_hunters")
	
	if likes_to_talk:
		states.set_next("soldier_idle")
	else:
		states.set_next("wolf_idle")

	bite_area.connect("body_entered", self, "_on_player_entered_bitable_area")
	bite_area.connect("body_exited", self, "_on_player_exited_bitable_area")

	actions_for_roar = actions_count_before_roar

func should_we_roar() -> bool:
	if actions_for_roar > 0:
		actions_for_roar -= 1
		return false
	else:
		actions_for_roar = actions_count_before_roar

	return true

func set_player_target(player) -> void:
	player_target = player

func set_enabled(do_we: bool) -> void:
	enabled = do_we
	visible = enabled
	
	$collision.set_deferred("disabled", not enabled)
	$collision2.set_deferred("disabled", not enabled)
	$invisible_wall/collision.set_deferred("disabled", not enabled)
	
	set_physics_process(enabled)


func _on_player_entered_bitable_area(player) -> void:
	is_player_bitable = true

func _on_player_exited_bitable_area(player) -> void:
	is_player_bitable = false
	

#func bullet_bleed_hit(bullet_type: int) -> void:
func bullet_bleed_hit(bullet_type: int, hit_pos: Vector2, normal: Vector2) -> void:
	var modifier: float

	match bullet_type:
		Game.BulletTypes.Silver:
			modifier = 4.0
			Game.fx_master.bullet_bleed_hit_spark(hit_pos, normal)
		Game.BulletTypes.Obsidian:
			modifier = 0.0
			Game.fx_master.bullet_armored_hit_spark(hit_pos, normal)
		_:
			modifier = 1.0
			Game.fx_master.bullet_bleed_hit_spark(hit_pos, normal)

	health -= Game.get_bullet_damage(bullet_type) * modifier
	

	
	if health <= 0.0:
		die()


func die() -> void:
	emit_signal("wolf_death")
	Game.fx_master.blood_explode_spark(position)
	queue_free()


func set_facing(right: bool) -> void:
	
	sprite.flip_h = right
	
	if right:
		bite_area.position.x = abs(bite_area.position.x)
	else:
		bite_area.position.x = -abs(bite_area.position.x)

func _physics_process(delta):
	if enabled:
		states.run(delta)
	else:
		set_physics_process(false)

	

func get_talk_position() -> Vector2:
	return talk_position.get_global_transform_with_canvas().get_origin()


func transformate() -> void:
	states.set_next("transform")
	
