extends KinematicBody2D

onready var states = $states
onready var anims = $anims
onready var sprite = $sprite
onready var visibility_area = $visibility_area
onready var damage_area = $damage_area

export (float) var attack_damage = 2.0
export (float) var touch_damage = 2.5
export (float) var patrol_speed = 70.0
export (float) var patrol_slowdown_radius = 50.0
export (float) var pursue_speed = 90.0
export (float) var attack_radius = 180.0
export (float) var attack_speed = 250.0
export (float) var attack_position_length = 100.0
export (float) var health = 4.0

var route = []
var velocity: Vector2
var steering: Vector2
var facing: bool
var target = null
var _visibility_area_default_pos: Vector2
var player_is_hurt: bool = false
var attacking: bool = false

func _ready():
	
	
	for i in range(get_child_count()):
		var child  = get_child(i)
		
		if child is Line2D:
			for j in range(child.points.size()):
				route.push_back(child.points[j] + position)
			child.queue_free()
			

	_visibility_area_default_pos = visibility_area.position
	
	damage_area.connect("body_entered", self, "_on_player_damaged")
	damage_area.connect("body_exited", self, "_on_player_out")

func set_facing(is_right: bool) -> void:
	
	if facing == is_right:
		return
	
	facing = is_right
	
	sprite.flip_h = is_right
	
	if visibility_area != null:
		if is_right:
			visibility_area.position = -_visibility_area_default_pos
		else:
			visibility_area.position = _visibility_area_default_pos
		


func _process(delta: float) -> void:

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
	
	if health <= 0.0:
		die()

func die() -> void:
	Game.fx_master.blood_explode_spark(position)
	queue_free()


func _on_player_damaged(player) -> void:
	
	if not player_is_hurt:
		player_is_hurt = true
		
		if attacking:
			player.hit(attack_damage)
		else:
			player.hit(touch_damage)
		

func _on_player_out(player) -> void:
	
		player_is_hurt = false


func add_velocities(max_speed: float) -> void:
	velocity = (velocity + steering).clamped(max_speed)
	
func arrive(pos: Vector2, slowing_radius: float, max_speed: float) -> float:
	var direction : Vector2 = pos - position
	var distance : float = direction.length()
	var desired_vel : Vector2 = direction.normalized()
	
	if distance < slowing_radius:
		desired_vel = desired_vel * max_speed * Smoothstep.start2(distance / slowing_radius)
	else:
		desired_vel = desired_vel * max_speed
	
	steering = desired_vel - velocity

	return distance
	

