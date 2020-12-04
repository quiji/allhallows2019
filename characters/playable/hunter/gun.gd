extends RayCast2D

signal bullet_shot
signal must_reload
signal magazine_reloaded(ammo, type)
signal magazine_change(ammo, type)

onready var line : Line2D = $bullet_line
onready var muzzle = $muzzle
onready var shoot = $shoot
onready var out_of_ammo = $out_of_ammo


var bullet_type: int setget set_bullet_type
var bullet_line: int = 4
var target_pos: Vector2
var delta_count: float = 0.0

var ammo_count: int = 18


func _ready():
	set_process(false)
	line.hide()

func can_shoot() -> bool:
	return not is_processing()

func set_bullet_type(new_type: int) -> void:
	bullet_type = new_type
	ammo_count = Game.get_magazine_size(bullet_type)
	emit_signal("magazine_change", ammo_count, bullet_type)

func get_ammo(if_out_play_sfx:bool=true) -> int:
	if ammo_count == 0:
		out_of_ammo.play()

	return ammo_count

func reload() -> void:

	if ammo_count > 0 and GameState.get_bullet_type_ammo(bullet_type) != -1:
		GameState.add_bullet_type_ammo(bullet_type, ammo_count)
	
	if bullet_type != GameState.current_bullet_type:
		bullet_type = GameState.current_bullet_type
	
	var remaining_ammo: int = GameState.get_bullet_type_ammo(bullet_type)
	var magazine_capacity: int = Game.get_magazine_size(bullet_type)
	
	if remaining_ammo < magazine_capacity and remaining_ammo != -1:
		magazine_capacity = remaining_ammo
	
	ammo_count = magazine_capacity
	
	if remaining_ammo != -1:
		GameState.sub_bullet_type_ammo(bullet_type, magazine_capacity)

	emit_signal("magazine_reloaded", ammo_count, bullet_type)

func _process(delta):
	delta_count += delta

	match bullet_line:
		0:
			line.width = 3
			line.set_point_position(0, Vector2())
			line.set_point_position(1, target_pos)
			line.default_color = Game.gut_bullet_line_color(bullet_type, true)
			line.show()

		1:
			line.set_point_position(0, Vector2(10.0, 0))
			line.set_point_position(1, target_pos - Vector2(10, 0.0))
			line.width = 2
			line.default_color = Game.gut_bullet_line_color(bullet_type, false)
		2:
			line.width = 1

			line.set_point_position(0, Vector2(20.0, 0))
			line.set_point_position(1, target_pos - Vector2(20.0, 0.0))


		3:
			line.set_point_position(0, Vector2())
			line.set_point_position(1, Vector2())
			line.hide()
		4:
			#this is to lower the fire rate
			set_process(false)


	if delta_count >= 0.02:
		bullet_line += 1
		delta_count = 0

	
func shoot_bullet(pos: Vector2, direction: Vector2, case_pos: Vector2) -> void:
	
	position = pos - direction * 20.0
	rotation = direction.angle()
	
	ammo_count -= 1
	
	if ammo_count == 0:
		emit_signal("must_reload")
	
	muzzle.spark()
	shoot.play()
	force_raycast_update()
	
	var length: float = cast_to.x
	
	var hit_pos : Vector2
	var collider = null
	var normal : Vector2
	
	if is_colliding():
		hit_pos = get_collision_point()
		collider = get_collider()
		normal = get_collision_normal()
	
	
	if collider != null:
		
		if collider.has_method("bullet_bleed_hit"):
			
			collider.bullet_bleed_hit(bullet_type, hit_pos - Game.level.position, normal)
			
			#Game.fx_master.bullet_bleed_hit_spark(hit_pos - Game.level.position, normal)
		elif collider.has_method("bullet_hit"):
			collider.bullet_hit(bullet_type, hit_pos - Game.level.position, normal)

		else:
			Game.fx_master.bullet_hit_spark(hit_pos - Game.level.position, normal)
		#target_pos = (hit_pos - line.global_position).length() / (cast_to.length() - 20.0) * cast_to 
		length = (hit_pos - line.global_position).length()
		target_pos = length * Vector2(1, 0)


	else:
		target_pos = cast_to - line.position

	if length > 40.0:
		bullet_line = 0
		delta_count = 0
		set_process(true)


	Game.fx_master.bullet_casing_spark(case_pos, direction, bullet_type)
	emit_signal("bullet_shot")

