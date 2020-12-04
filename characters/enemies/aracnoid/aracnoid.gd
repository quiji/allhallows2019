extends KinematicBody2D

const RIGHT_FACING: bool = true

signal aracnoid_hurt

onready var sprite = $sprite
onready var anims = $anims
onready var states = $states
onready var visibility_area = $visibility_area
onready var damage_area = $damage_area
onready var ground_cast = $ground_cast
onready var left_fall_cast = $left_fall_cast
onready var right_fall_cast = $right_fall_cast
onready var collision = $collision

export (float) var walk_speed = 110.0#85.0
export (float) var attack_speed = 190.0
export (float) var attack_damage = 4.0
export (float) var touch_damage = 2.5
export (float) var health = 8.0
export (float) var jump_height = 128.0
export (float) var fall_time = 0.5


var facing: bool = false
var velocity: Vector2
var _visibility_area_pos: Vector2
var target = null

var jump_time: float = 0.0
var jump_direction: float = 0.0
var current_attack_speed : float = 0.0

var player_is_hurt: bool = false
var attacking: bool = false


var current_direction: bool = false

var end_limit: float = 0.0
var start_limit: float = 0.0

func _ready():
	_visibility_area_pos = visibility_area.position


	for i in range(get_child_count()):
		var child  = get_child(i)
		
		if child is Position2D:

			end_limit = child.global_position.x
			start_limit = global_position.x
				
			child.queue_free()

	damage_area.connect("body_entered", self, "_on_player_damaged")
	damage_area.connect("body_exited", self, "_on_player_out")


func set_facing(is_right: bool) -> void:
	
	if facing == is_right:
		return
	
	facing = is_right
	
	sprite.flip_h = is_right


	if visibility_area != null:
		if is_right:
			visibility_area.position = -_visibility_area_pos
		else:
			visibility_area.position = _visibility_area_pos

func can_walk() -> bool:
	if facing == RIGHT_FACING:
		return  right_fall_cast.is_colliding()
	else:
		return  left_fall_cast.is_colliding()

func _on_player_damaged(player) -> void:
	
	if not player_is_hurt:
		player_is_hurt = true
		if attacking:
			player.hit(attack_damage)
		else:
			player.hit(touch_damage)

	if states.current_is("seek"):
		states.set_next("start_jump")

func _on_player_out(player) -> void:
	
		player_is_hurt = false

func _process(delta):
	states.run(delta)

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
	
	emit_signal("aracnoid_hurt")
	
	if health <= 0.0:
		die()

func die() -> void:
	Game.fx_master.blood_explode_spark(position)
	queue_free()
