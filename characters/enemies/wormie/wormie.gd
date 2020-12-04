extends KinematicBody2D

onready var damage_area = $damage_area
onready var sprite = $wormie_sprite
onready var states = $states
onready var anims = $anims

export (float) var walk_speed = 90.0
export (float) var touch_damage = 2.5
export (float) var health = 3.0

var facing: bool = false
var player_is_hurt: bool = false
var velocity: Vector2
#var start_limit: float = 0.0
#var end_limit: float = 0.0
var start_limit: Vector2
var end_limit: Vector2
var wait_time: float = 0.0

func _ready():
	
	for i in range(get_child_count()):
		var child  = get_child(i)
		
		if child is Position2D:

			end_limit = child.global_position
			start_limit = global_position
				
			child.queue_free()
	
	damage_area.connect("body_entered", self, "_on_player_damaged")
	damage_area.connect("body_exited", self, "_on_player_out")
	
	wait_time = rand_range(0.0, 4.0)

func set_facing(is_right: bool) -> void:
	
	
	if facing == is_right:
		return
	
	facing = is_right
	
	sprite.flip_h = is_right


func _on_player_damaged(player) -> void:
	
	if not player_is_hurt:
		player_is_hurt = true

		player.hit(touch_damage)

func _on_player_out(player) -> void:
	
		player_is_hurt = false
		
		
func _process(delta):
	if wait_time <= 0:
		states.run(delta)
	else:
		wait_time -= delta


func bullet_bleed_hit(bullet_type: int, hit_pos: Vector2, normal: Vector2) -> void:
	

	var modifier: float
	match bullet_type:
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
	Game.fx_master.blood_explode_spark(position)
	queue_free()
