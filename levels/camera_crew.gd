
extends Node2D

signal film_point_finished
signal actore_restore_finished

enum CameraModes {FollowActor, FilmPoint, Wait, ActorRestore}

onready var limit_area_sensor = $limit_area_sensor

export (int) var limit_left  setget set_limit_left, get_limit_left
export (int) var limit_right  setget set_limit_right, get_limit_right
export (int) var limit_top  setget set_limit_top, get_limit_top
export (int) var limit_bottom  setget set_limit_bottom, get_limit_bottom

var actor setget set_actor

var mode 

var camera_pos_target : Vector2
var camera_pos_start : Vector2
var film_point_duration : float = 2.0
var camera_t: float = 0.0

var actor_restore_duration : float = 1.4

var interpolate_limits = {
	start_left = 0.0,
	start_right = 0.0,
	start_top = 0.0,
	start_bottom = 0.0,
	end_left = 0.0,
	end_right = 0.0,
	end_top = 0.0,
	end_bottom = 0.0,
	t = 0.0,
	working = false,
	#duration = 0.6
	duration = 1.4

}

func _ready():
	
	if Engine.editor_hint:
		set_physics_process(false)
		
	limit_area_sensor.connect("area_entered", self, "_on_limit_area_entered")

func set_limit_left(new_l: int) -> void: 
	if has_node("camera_man"):
		$camera_man.limit_left = new_l
	
func get_limit_left() -> int: 
	if has_node("camera_man"):
		return $camera_man.limit_left
	return 0

func set_limit_right(new_l: int) -> void: 
	if has_node("camera_man"):
		$camera_man.limit_right = new_l
	
func get_limit_right() -> int: 
	if has_node("camera_man"):
		return $camera_man.limit_right
	return 0

func set_limit_top(new_l: int) -> void: 
	if has_node("camera_man"):
		$camera_man.limit_top = new_l

func get_limit_top() -> int: 
	if has_node("camera_man"):
		return $camera_man.limit_top
	return 0

func set_limit_bottom(new_l: int) -> void: 
	if has_node("camera_man"):
		$camera_man.limit_bottom = new_l

func get_limit_bottom() -> int: 
	if has_node("camera_man"):
		return $camera_man.limit_bottom
	return 0


func set_actor(who) -> void:
	
	actor = who
	mode = CameraModes.FollowActor


func _on_limit_area_entered(limit_area: Area2D) -> void:
	
	if not limit_area.interpolate:
	
		self.limit_left = limit_area.limit_left
		self.limit_right = limit_area.limit_right
		self.limit_bottom = limit_area.limit_bottom
		self.limit_top = limit_area.limit_top
	else:
		interpolate_limits.working = true
		interpolate_limits.t = 0.0
		interpolate_limits.start_left = self.limit_left
		interpolate_limits.start_right = self.limit_right
		interpolate_limits.start_top = self.limit_top
		interpolate_limits.start_bottom = self.limit_bottom

		interpolate_limits.end_left = limit_area.limit_left
		interpolate_limits.end_right = limit_area.limit_right
		interpolate_limits.end_top = limit_area.limit_top
		interpolate_limits.end_bottom = limit_area.limit_bottom
	

func film_point(where: Vector2) -> void:
	mode = CameraModes.FilmPoint
	camera_t = 0.0
	camera_pos_target = where
	camera_pos_start = position

func actore_restore() -> void:
	mode = CameraModes.ActorRestore

	camera_t = 0.0
	camera_pos_target = actor.position
	camera_pos_start = position



func _physics_process(delta):
	
	
	match mode:
		CameraModes.FollowActor:
			Console.add_log("camera_mode", "FollowActor")
			position = actor.position
		CameraModes.FilmPoint:
			Console.add_log("camera_mode", "FilmPoint")
			if camera_t <= 1.0:
				
				position = camera_pos_start.linear_interpolate(camera_pos_target, Smoothstep.stop2(camera_t))
				
				camera_t += delta / film_point_duration
				
			else:
				emit_signal("film_point_finished")

				mode = CameraModes.Wait
				
		CameraModes.ActorRestore:
			Console.add_log("camera_mode", "ActorRestore")
			if camera_t <= 1.0:
				
				
				position = camera_pos_start.linear_interpolate(camera_pos_target, Smoothstep.start2(camera_t))
				
				camera_t += delta / actor_restore_duration
				
			else:
				emit_signal("actore_restore_finished")

				mode = CameraModes.FollowActor

		CameraModes.Wait:
			Console.add_log("camera_mode", "Wait")

			pass
			

	if interpolate_limits.working:
		
		var t: float = interpolate_limits.t
		self.limit_left = lerp(interpolate_limits.start_left, interpolate_limits.end_left, t)
		self.limit_right = lerp(interpolate_limits.start_right, interpolate_limits.end_right, t)
		self.limit_top = lerp(interpolate_limits.start_top, interpolate_limits.end_top, t)
		self.limit_bottom = lerp(interpolate_limits.start_bottom, interpolate_limits.end_bottom, t)
		
		interpolate_limits.t += delta / interpolate_limits.duration
		
		if interpolate_limits.t > 1.0:
			interpolate_limits.working = false
			self.limit_left = interpolate_limits.end_left
			self.limit_right = interpolate_limits.end_right
			self.limit_top = interpolate_limits.end_top
			self.limit_bottom = interpolate_limits.end_bottom

func werewolf_bit_shake(hit: bool=false):

	if not hit:
		$camera_man.shake.shake(1.0, 2.0, PI/400.0, $camera_man.shake.ShakeDirectionTypes.Y_AXIS, $camera_man.shake.ShakeMovementTypes.STRONG_TO_LOW)
	else:
		$camera_man.shake.shake(0.8, 4.0, PI/200.0, $camera_man.shake.ShakeDirectionTypes.Y_AXIS, $camera_man.shake.ShakeMovementTypes.STRONG_TO_LOW)
	

func aracnoid_smash():
	
	$camera_man.shake.shake(1.0, 7.0, 0.0, $camera_man.shake.ShakeDirectionTypes.Y_AXIS, $camera_man.shake.ShakeMovementTypes.STRONG_TO_LOW)


	
