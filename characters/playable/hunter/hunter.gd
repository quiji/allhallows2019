extends KinematicBody2D

signal health_change(ratio)
signal forced_position_reached

onready var states: CharacterActionStates = $states
onready var jump_physics: JumpPhysics = $jump_physics
onready var left_ground_cast: RayCast2D = $left_ground_cast
onready var right_ground_cast: RayCast2D = $right_ground_cast
onready var wall_kick_cast: RayCast2D = $wall_kick_cast
onready var gun: RayCast2D = $gun
onready var sprite_anims = $sprites
onready var talk_position = $talk

export (float) var run_speed = 110.0
#export (float) var walk_speed = 60.0
export (float) var walk_speed = 50.0
export (float) var coyote_time = 0.1
export (float) var max_health = 20.0


const FACING_LEFT = -1.0
const FACING_RIGHT = 1.0

var facing: float = 0.0 setget set_facing
var velocity: Vector2 = Vector2()
var fall_delta: float = 0.0
var health: float = 0.0

var blocked: bool = false setget set_blocked

var is_forcing_position: bool = false
var forced_position: Vector2
var talker_position
var forced_position_lenght: float
var forced_position_direction: Vector2
var forced_position_met: bool = false

var closest_door = null
var closest_item_box = null
var closest_talk_prompt = null

func _ready() -> void:
	
	sprite_anims.connect("gun_fired", self, "_on_gun_fired")


	if GameState.unloaded:
		GameState.solomon_health = max_health
		health = max_health
		GameState.unloaded = false
	else:
		health = GameState.solomon_health

	
	
func update_game_state() -> void:
	gun.bullet_type = GameState.current_bullet_type
	

func set_facing(where: float) -> void:
	if facing == where:
		return
	facing = where
	
	sprite_anims.facing = where
	wall_kick_cast.cast_to.x = abs(wall_kick_cast.cast_to.x) * where

func hit(damage: float) -> void:
	
	if states.current_is("hit"):
		return 
	
	
	states.set_next("hit")


	health -= damage
	
	if health <= 0.0:
		Game.hit_freeze(2.0, 0.1)
		Game.level.gui.death_screen()
		GameState.solomon_health = max_health
	else:
		Game.hit_freeze(0.1, 0.1)
		GameState.solomon_health = health


	emit_signal("health_change", health / max_health)
	
func get_health_ratio() -> float:
	return health / max_health
	
func _on_screen_blackened() -> void:
	get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	
	states.run(delta)

	if left_ground_cast.is_colliding() or right_ground_cast.is_colliding():
		fall_delta = 0.0
	else:
		fall_delta += delta
		

func set_blocked(is_it: bool) -> void:
	blocked = is_it
	
	set_physics_process(not blocked)

func set_free() -> void:
	is_forcing_position = false


func force_to_position(where: Vector2, talker_pos=null) -> void:
	is_forcing_position = true
	forced_position = where
	talker_position = talker_pos
	forced_position_met = false

func get_forcing_position_distance() -> float:
	forced_position_direction = forced_position - position
	forced_position_lenght = forced_position_direction.length()
	forced_position_direction = forced_position_direction.normalized()

	return forced_position_lenght

func get_talk_position() -> Vector2:
	return talk_position.get_global_transform_with_canvas().get_origin()

func reached_ground(coyote_time: float = 0.0) -> bool:
	return (is_on_floor() and (left_ground_cast.is_colliding() or right_ground_cast.is_colliding()) or fall_delta <= coyote_time)
	
func can_wall_kick() -> bool:
	return wall_kick_cast.is_colliding()

func _on_gun_fired(pos: Vector2, direction: Vector2, case_pos: Vector2) -> void:
	gun.shoot_bullet(pos, direction, case_pos + position)


func get_gun():
	return gun

func can_reload() -> bool:
	var remaining_bullets = GameState.get_bullet_type_ammo(GameState.current_bullet_type)
	
	return remaining_bullets == -1 or remaining_bullets > 0


func at_door(which_door):
	closest_door = which_door

func left_door():
	closest_door = null

func at_item_box(which_box):
	closest_item_box = which_box

func left_item_box():
	closest_item_box = null

func at_talk_prompt(which_talk):
	closest_talk_prompt = which_talk

func left_talk_prompt():
	closest_talk_prompt = null
