extends Node2D

onready var anims = $anims
onready var tune_timer = $tune_timer

var blues_played: bool = false

func _ready():

	position.x += position.x * (get_parent().motion_scale.x - 1.0)
	position.y += position.y * (get_parent().motion_scale.y - 1.0)

	tune_timer.connect("timeout", self, "_on_timeout")
	anims.play("Talking")
	tune_timer.start(10.0)
	anims.get_animation("FastSwingIntro").loop = false
	anims.connect("animation_finished", self, "_on_anim_finished")

	Maestro.connect("jazz_band_finished", self, "_on_jazz_band_finished")

func _on_timeout():
	anims.play("FastSwingIntro")

	Maestro.jazz_band(not blues_played)
	blues_played = not blues_played
	

func _on_jazz_band_finished():
	anims.play("Talking")
	tune_timer.start(10.0)


func _on_anim_finished(anim_name: String): 

	if anim_name == "FastSwingIntro":
		anims.play("FastSwing")
