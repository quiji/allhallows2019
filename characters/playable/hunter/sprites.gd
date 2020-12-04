tool
extends Node2D


const FACING_LEFT = -1.0
const FACING_RIGHT = 1.0

enum ShootDirection {Front, Up, Down}

signal action_finished(which)
signal gun_fired(pos, dir, case_pos)


export (bool) var update = false setget set_update
#export (float) var shoot_cancel_time = 0.2
#export (float) var shoot_cancel_time = 0.3
#export (float) var shoot_cancel_time = 0.4
#export (float) var shoot_cancel_time = 0.6
#export (float) var shoot_cancel_time = 0.5
#export (float) var shoot_cancel_time = 1.0

var facing : float = 1.0 setget set_facing
var playing : String = ""
var gun_playing : String = ""
var gun_force_idle: bool = false

var is_reloading: bool = false
var was_shooting: bool = false

func _ready():
	
	$anims.connect("animation_finished", self, "_on_animation_finished")
	$gun_anims.connect("animation_finished", self, "_on_gun_animation_finished")
	
	_play_shoot_anim("Idle")
	
func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return


	$anims.get_animation("rg-JumpPeak").loop = false
	$anims.get_animation("lf-JumpPeak").loop = false
	$anims.get_animation("rg-Land").loop = false
	$anims.get_animation("lf-Land").loop = false
	$anims.get_animation("rg-StartWallKick").loop = false
	$anims.get_animation("lf-StartWallKick").loop = false
	$anims.get_animation("rg-Reload").loop = false
	$anims.get_animation("rg-IdleToReload").loop = false
	$anims.get_animation("rg-ShootToReload").loop = false
	$anims.get_animation("lf-Reload").loop = false
	$anims.get_animation("lf-IdleToReload").loop = false
	$anims.get_animation("lf-ShootToReload").loop = false
	$anims.get_animation("rg-Hurt").loop = false
	$anims.get_animation("lf-Hurt").loop = false
	$anims.get_animation("rg-ReloadAndWalk").loop = false
	$anims.get_animation("lf-ReloadAndWalk").loop = false
	$anims.get_animation("rg-BoxOpen").loop = false
	$anims.get_animation("lf-BoxOpen").loop = false
	$anims.get_animation("rg-BoxToIdle").loop = false
	$anims.get_animation("lf-BoxToIdle").loop = false

	var shooting_anims : Animation 
	var track_idx: int 
	
	shooting_anims = $anims.get_animation("rg-Run")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")

		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.1, Vector2(-7.0, -24.0))
		shooting_anims.track_insert_key(track_idx, 0.2, Vector2(-7.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.3, Vector2(-7.0, -27.0))
		shooting_anims.track_insert_key(track_idx, 0.4, Vector2(-7.0, -26.0))
		shooting_anims.track_insert_key(track_idx, 0.5, Vector2(-7.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.6, Vector2(-7.0, -24.0))
		shooting_anims.track_insert_key(track_idx, 0.7, Vector2(-7.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.8, Vector2(-7.0, -27.0))
		shooting_anims.track_insert_key(track_idx, 0.9, Vector2(-7.0, -26.0))

		
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

		track_idx = shooting_anims.add_track(Animation.TYPE_AUDIO)
		shooting_anims.track_set_path(track_idx, "concrete_steps")
		shooting_anims.audio_track_insert_key(track_idx, 0.0, $concrete_steps.stream)
		shooting_anims.audio_track_insert_key(track_idx, 0.5, $concrete_steps.stream)



	
	shooting_anims = $anims.get_animation("rg-Idle")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
	
	
	shooting_anims = $anims.get_animation("rg-StartJump")
	shooting_anims.loop = false
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -15.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("rg-Jump")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("rg-JumpPeak")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)


	shooting_anims = $anims.get_animation("rg-Fall")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)


	shooting_anims = $anims.get_animation("rg-Land")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-7.0, -16.0))
		shooting_anims.track_insert_key(track_idx, 0.1, Vector2(-7.0, -15.0))
		shooting_anims.track_insert_key(track_idx, 0.2, Vector2(-7.0, -21.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	
	shooting_anims = $anims.get_animation("lf-Run")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.1, Vector2(-3.0, -24.0))
		shooting_anims.track_insert_key(track_idx, 0.2, Vector2(-3.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.3, Vector2(-3.0, -27.0))
		shooting_anims.track_insert_key(track_idx, 0.4, Vector2(-3.0, -26.0))
		shooting_anims.track_insert_key(track_idx, 0.5, Vector2(-3.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.6, Vector2(-3.0, -24.0))
		shooting_anims.track_insert_key(track_idx, 0.7, Vector2(-3.0, -25.0))
		shooting_anims.track_insert_key(track_idx, 0.8, Vector2(-3.0, -27.0))
		shooting_anims.track_insert_key(track_idx, 0.9, Vector2(-3.0, -26.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
		track_idx = shooting_anims.add_track(Animation.TYPE_AUDIO)
		shooting_anims.track_set_path(track_idx, "concrete_steps")
		shooting_anims.audio_track_insert_key(track_idx, 0.0, $concrete_steps.stream)
		shooting_anims.audio_track_insert_key(track_idx, 0.5, $concrete_steps.stream)


	shooting_anims = $anims.get_animation("lf-Idle")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
	
	
	shooting_anims = $anims.get_animation("lf-StartJump")
	shooting_anims.loop = false
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -15.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("lf-Jump")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("lf-JumpPeak")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("lf-Fall")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -25.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)

	shooting_anims = $anims.get_animation("lf-Land")
	if shooting_anims.find_track("gun:position") == -1:
		track_idx = shooting_anims.add_track(Animation.TYPE_VALUE)
		shooting_anims.track_set_path(track_idx, "gun:position")
		shooting_anims.track_insert_key(track_idx, 0.0, Vector2(-3.0, -16.0))
		shooting_anims.track_insert_key(track_idx, 0.1, Vector2(-3.0, -15.0))
		shooting_anims.track_insert_key(track_idx, 0.2, Vector2(-3.0, -21.0))
		shooting_anims.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)



	$gun.centered = false

	shooting_anims = $gun_anims.get_animation("rg-ShootToIdle")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.loop = false
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-6.0, -14.0))

	shooting_anims = $gun_anims.get_animation("rg-Shoot")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.loop = false
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-6.0, -14.0))


	shooting_anims = $gun_anims.get_animation("rg-Idle")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-6, -14))


	shooting_anims = $gun_anims.get_animation("rg-IdleStartJump")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-13, -3))

	shooting_anims = $gun_anims.get_animation("rg-IdleJump")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-13, -3))

	shooting_anims = $gun_anims.get_animation("rg-IdleJumpPeak")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-13, -8))

	shooting_anims = $gun_anims.get_animation("rg-IdleFall")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-13, -15))

	shooting_anims = $gun_anims.get_animation("rg-IdleLand")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-13, -8))

	shooting_anims = $gun_anims.get_animation("rg-UpShoot")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-13, -18))

	shooting_anims = $gun_anims.get_animation("rg-DownShoot")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-12, 0))


	shooting_anims = $gun_anims.get_animation("lf-ShootToIdle")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.loop = false
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-28, -14))

	shooting_anims = $gun_anims.get_animation("lf-Shoot")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.loop = false
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-28, -14))

	shooting_anims = $gun_anims.get_animation("lf-Idle")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-28, -14))


	shooting_anims = $gun_anims.get_animation("lf-IdleStartJump")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-14, -3))


	shooting_anims = $gun_anims.get_animation("lf-IdleJump")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-14, -3))

	shooting_anims = $gun_anims.get_animation("lf-IdleJumpPeak")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-14, -8))

	shooting_anims = $gun_anims.get_animation("lf-IdleFall")
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-14, -15))

	shooting_anims = $gun_anims.get_animation("lf-IdleLand")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0, Vector2(-14, -8))

	shooting_anims = $gun_anims.get_animation("lf-UpShoot")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-16, -16))

	shooting_anims = $gun_anims.get_animation("lf-DownShoot")
	shooting_anims.loop = false
	track_idx = shooting_anims.find_track("gun:offset")
	shooting_anims.track_set_key_value(track_idx, 0.0, Vector2(-15, 1))

func set_facing(where: float) -> void:
	if where == facing:
		return
		
	facing = where

	var current_time : float = $anims.current_animation_position

	if facing == FACING_LEFT:
		$anims.play("lf-" + playing)

		if $gun.visible and $gun_anims.is_playing():
			if gun_playing == "Shoot":
				gun_force_idle = true
			else:
				_play_shoot_anim("Idle")
	else:
		$anims.play("rg-" + playing)

		if $gun.visible and $gun_anims.is_playing():
			if gun_playing == "Shoot":
				gun_force_idle = true
			else:
				_play_shoot_anim("Idle")
				
	$anims.seek(current_time, true)
	
func run() -> void:
	
	var was_visible: bool = $gun.visible
	$gun.show()
	
	if _play_face_anim("Run") and not is_shooting():
		if gun_playing == "Shoot" and was_visible:
			_play_shoot_anim("ShootToIdle")
		else:
			_play_shoot_anim("Idle")

func idle() -> void:
	var was_visible: bool = $gun.visible
	$gun.show()

	if _play_face_anim("Idle") and  not is_shooting():
		if gun_playing == "Shoot" and was_visible:
			_play_shoot_anim("ShootToIdle")
		else:
			_play_shoot_anim("Idle")
	
func shoot(dir: int, out_of_ammo:bool=false) -> void:
	

	#if gun_playing == "Shoot" and $gun_anims.is_playing() and $gun_anims.current_animation_position >= shoot_cancel_time:
	#	$gun_anims.stop()

	gun_force_idle = false

	var pos : Vector2
	var direction : Vector2
	var case_pos : Vector2

	match dir:
		ShootDirection.Front:
			_play_shoot_anim("Shoot")
			
			if facing == FACING_RIGHT:
				pos = $gun/right.position + $gun.position
				direction = Vector2(1, 0)
				case_pos = $gun/right_casing.position + $gun.position
			else:
				pos = $gun/left.position + $gun.position
				direction = Vector2(-1, 0)
				case_pos = $gun/left_casing.position + $gun.position

		ShootDirection.Up:
			_play_shoot_anim("UpShoot")

			direction = Vector2(0, -1)
			if facing == FACING_RIGHT:
				pos = $gun/right_up.position + $gun.position
				case_pos = $gun/right_up_casing.position + $gun.position
			else:
				pos = $gun/left_up.position + $gun.position
				case_pos = $gun/left_up_casing.position + $gun.position

		ShootDirection.Down:
			_play_shoot_anim("DownShoot")

			direction = Vector2(0, 1)
			if facing == FACING_RIGHT:
				pos = $gun/right_down.position + $gun.position
				case_pos = $gun/right_down_casing.position + $gun.position
			else:
				pos = $gun/left_down.position + $gun.position
				case_pos = $gun/left_down_casing.position + $gun.position

	if not out_of_ammo:
		emit_signal("gun_fired", pos + position, direction, case_pos + position)
	else:
		$gun_anims.seek(0.0, true)
		$gun_anims.stop()



func reload() -> void:

	$gun.hide()
	$reload.play()
	
	is_reloading = true
	
	match gun_playing:
		"Idle":
			was_shooting = false
			_play_face_anim("IdleToReload")
		"Shoot":
			was_shooting = true
			_play_face_anim("ShootToReload")
		"ShootToIdle":
			was_shooting = false
			_play_face_anim("IdleToReload")
		_:
			was_shooting = false
			_play_face_anim("IdleToReload")
		

func hit() -> void:

	$gun.hide()
	_play_face_anim("Hurt")

func box_open() -> void:

	$gun.show()
	_play_face_anim("BoxOpen")



func jump() -> void:

	var was_visible: bool = $gun.visible
	$gun.show()

	$concrete_jump.play()

	_play_face_anim("Jump")
	
	if not is_shooting():
		_play_shoot_anim("IdleJump")


func start_jump() -> void:
	
	var was_visible: bool = $gun.visible
	$gun.show()

	_play_face_anim("StartJump")

	if not is_shooting():
		_play_shoot_anim("IdleStartJump")


func is_start_jump() -> bool: return playing == "StartJump"

func start_wall_kick() -> void:

	$gun.hide()
	_play_face_anim("StartWallKick")

func is_start_wall_kick() -> bool: return playing == "StartWallKick"

func jump_peak() -> void:
	
	var was_visible: bool = $gun.visible
	$gun.show()

	_play_face_anim("JumpPeak")

	if not is_shooting():
		_play_shoot_anim("IdleJumpPeak")


func is_jump_peak() -> bool: return playing == "JumpPeak"

func fall() -> void:
	
	var was_visible: bool = $gun.visible
	$gun.show()

	_play_face_anim("Fall")

	if not is_shooting():
		_play_shoot_anim("IdleFall")


func land() -> void:
	
	var was_visible: bool = $gun.visible
	$gun.show()

	$concrete_land.play()

	_play_face_anim("Land")

	if not is_shooting():
		_play_shoot_anim("IdleLand")


func _on_animation_finished(anim_name: String) -> void:
	
	

	match playing:
		"Land":
			idle()
		"JumpPeak":
			fall()
		"StartJump":
			jump()
		"StartWallKick":
			jump()
		"IdleToReload":
			if is_reloading:
				_play_face_anim("Reload")
			else:
				emit_signal("action_finished", "Reload")
		"ShootToReload":
			if is_reloading:
				_play_face_anim("Reload")
			else:
				emit_signal("action_finished", "Reload")
		"Reload", "ReloadAndWalk":
			is_reloading = false
			_play_face_anim("IdleToReload")
		"Hurt":
			emit_signal("action_finished", "Hit")
		"BoxOpen":
			emit_signal("action_finished", "BoxOpen")
			_play_face_anim("BoxToIdle")


func swap(which: String) -> void:
	if is_reloading:
		_play_face_anim(which, true)
	
	
func _play_face_anim(which: String, is_simile: bool = false) -> bool:

	if which == playing:
		return false
	
	var current_time: float = 0.0 
	
	if is_simile:
		current_time = $anims.current_animation_position
	
	if facing == FACING_LEFT:
		$anims.play("lf-" + which)
	else:
		$anims.play("rg-" + which)
		
	if is_simile:
		$anims.seek(current_time, true)
		
	playing = which
	return true

func _on_gun_animation_finished(anim_name: String) -> void:
	
	match gun_playing:
		"Shoot":
			if gun_force_idle:
				gun_force_idle = false
				_play_shoot_anim("ShootToIdle", true)
		"ShootToIdle":
				_play_shoot_anim("Idle")



func _play_shoot_anim(which: String, force_swap: bool = false) -> void:

	var current_time: float = 0.0 
	var _facing: float = facing
	
	if force_swap:
		_facing *= -1.0
	
	if gun_playing == which:
		$gun_anims.stop()
	
	if _facing == FACING_LEFT:
		$gun_anims.play("lf-" + which)
	else:
		$gun_anims.play("rg-" + which)
		
		
	gun_playing = which




func is_shooting() -> bool:
	return $gun.visible and (gun_playing == "Shoot" or gun_playing == "UpShoot" or gun_playing == "DownShoot") and $gun_anims.is_playing()

