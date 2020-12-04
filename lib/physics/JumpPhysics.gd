
extends Node
class_name JumpPhysics

#const INTERRUPT_THRESHOLD = 0.75
const INTERRUPT_MULTIPLIER = 1.8

var jump_delta := 0.0
var speed := 0.0
#var current_data : Dictionary
var current_data : Jump
#var jumps = []
var _current_gravity := 0.0
var falling := false
var gravity_modifier := 1.0 


"""
func append_jump(run_speedo: float, jump_height: float, total_distance: float, peak_point_t: float) -> void:
	var first_distance = total_distance * peak_point_t
	var second_distance = total_distance - first_distance


	var new_jump = {
		jump_time = first_distance / run_speedo,
		fall_time = second_distance / run_speedo
	}

	new_jump.initial_speed = 2 * jump_height / new_jump.jump_time
	new_jump.jump_gravity = -2 * jump_height / (new_jump.jump_time * new_jump.jump_time)

	new_jump.fall_gravity = -2 * jump_height / (new_jump.fall_time * new_jump.fall_time)
	jumps.append(new_jump)
"""

func set_gravity_modifier(new_mod: float) -> void:
	gravity_modifier = new_mod
	
func restart_gravity_modifier() -> void:
	gravity_modifier = 1.0

func start(jump_id: int, jump_ratio : float = 1.0) -> float:
	if jump_id >= get_child_count():
		return 0.0
		
	jump_delta = 0.0
	current_data = get_child(jump_id)
	speed = -current_data.initial_speed * jump_ratio
	_current_gravity = current_data.jump_gravity
	falling = false
	return -current_data.initial_speed

func fall(current_fall_speed : float = 0.0, jump_id: int = 0) -> void:
	if jump_id >= get_child_count():
		return

	jump_delta = 0.0
	speed = current_fall_speed
	current_data = get_child(jump_id)
	_current_gravity = current_data.fall_gravity
	falling = true

func get_fall_gravity(jump_id: int) -> float:
	if jump_id >= get_child_count():
		return 0.0

	return get_child(jump_id).fall_gravity

func process(delta) -> float:

	if not current_data:
		return 0.0
	"""
	if jump_delta <= current_data.jump_time:
		speed -= current_data.jump_gravity * delta
	else:
		speed -= current_data.fall_gravity * delta
	"""
	
	if jump_delta > current_data.jump_time and not falling: 
		_current_gravity = current_data.fall_gravity
		falling = true
	
	speed -= _current_gravity * delta * gravity_modifier
	jump_delta += delta

	return speed

func reached_peak() -> bool:
	return jump_delta > current_data.jump_time

func reaching_peak(percentage: float) -> bool:
	return (jump_delta / current_data.jump_time) > percentage

func interrupt() -> void:
	#if jump_delta < current_data.jump_time * INTERRUPT_THRESHOLD:
		#jump_delta = current_data.jump_time * INTERRUPT_THRESHOLD
	speed *= 0.5
	#_current_gravity = current_data.jump_gravity * INTERRUPT_MULTIPLIER
		#speed = current_data.initial_speed * (1.0 - INTERRUPT_THRESHOLD)
	
	

