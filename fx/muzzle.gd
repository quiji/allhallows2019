extends Node2D



func _ready():
	hide()
	
	$anims.connect("animation_finished", self, "_on_animation_finished")



	
func spark() -> void:
	
	if $sprite.frame + 1 < $sprite.vframes:
		$sprite.frame += 1
	else:
		$sprite.frame = 0

	show()
	$anims.play("muzzle")



func _on_animation_finished(anim_name: String) -> void:
	
	hide()

