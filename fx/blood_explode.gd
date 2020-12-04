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

	var shooting_anims : Animation = $anims.get_animation("bang")
	var track_idx : int = shooting_anims.find_track("sprite:offset")
	shooting_anims.loop = false
	shooting_anims.remove_track(track_idx)



func spark(pos: Vector2) -> void:
	
	position = pos
	
	show()
	$anims.play("bang")

func _on_animation_finished(wich_anim: String) -> void:
	hide()
	emit_signal("spark_finished", self)


