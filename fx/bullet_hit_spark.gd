tool
extends Node2D

signal spark_finished(who)

export (bool) var update = false setget set_update

func _ready():
	hide()
	
	$anims.connect("animation_finished", self, "_on_animation_finished")


func set_update(do_we: bool) -> void:
	if not Engine.editor_hint:
		return

	var shooting_anims : Animation = $anims.get_animation("spark")
	var track_idx : int = shooting_anims.find_track("spark:offset")
	shooting_anims.loop = false
	shooting_anims.remove_track(track_idx)


	shooting_anims = $anims.get_animation("blood_spark")
	track_idx = shooting_anims.find_track("blood_spark:offset")
	shooting_anims.loop = false
	shooting_anims.remove_track(track_idx)

	shooting_anims = $anims.get_animation("armored_spark")
	track_idx = shooting_anims.find_track("armored_spark:offset")
	shooting_anims.loop = false
	shooting_anims.remove_track(track_idx)



func spark(pos: Vector2, direction: Vector2) -> void:
	
	position = pos

	var target_direction: Vector2
	if Vector2(1, 0).dot(direction) > 0.5:
		target_direction = Vector2(1, 0)
	elif Vector2(0, -1).dot(direction) > 0.5:
		target_direction = Vector2(0, -1)
	elif Vector2(-1, 0).dot(direction) > 0.5:
		target_direction = Vector2(-1, 0)
	else:
		target_direction = Vector2(0, 1)
	
	rotation = target_direction.angle()
	
	show()
	$anims.play("spark")

func spark_blood(pos: Vector2, direction: Vector2) -> void:
	
	position = pos

	var target_direction: Vector2
	if Vector2(1, 0).dot(direction) > 0.5:
		target_direction = Vector2(1, 0)
	elif Vector2(0, -1).dot(direction) > 0.5:
		target_direction = Vector2(0, -1)
	elif Vector2(-1, 0).dot(direction) > 0.5:
		target_direction = Vector2(-1, 0)
	else:
		target_direction = Vector2(0, 1)
	
	rotation = target_direction.angle()
	
		
	show()
	$anims.play("blood_spark")

func spark_armored(pos: Vector2, direction: Vector2) -> void:
	
	position = pos

	var target_direction: Vector2
	if Vector2(1, 0).dot(direction) > 0.5:
		target_direction = Vector2(1, 0)
	elif Vector2(0, -1).dot(direction) > 0.5:
		target_direction = Vector2(0, -1)
	elif Vector2(-1, 0).dot(direction) > 0.5:
		target_direction = Vector2(-1, 0)
	else:
		target_direction = Vector2(0, 1)
	
	rotation = target_direction.angle()
	
		
	show()
	$anims.play("armored_spark")



func _on_animation_finished(wich_anim: String) -> void:
	hide()
	emit_signal("spark_finished", self)


