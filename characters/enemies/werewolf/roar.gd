extends CharacterAction



func install() -> void:
	pass


func start(sub_state: String) -> void:

	actor.anims.play("Roar")
	actor.howl_sfx.play()
	actor.anims.connect("animation_finished", self, "_on_animation_finished")
	
	if actor.direction.x >= 0:
		actor.set_facing(true)
	else:
		actor.set_facing(false)

	
func end(new_state: String) -> void:
	actor.anims.disconnect("animation_finished", self, "_on_animation_finished")
	
func _on_animation_finished(anim_name: String) -> void:

	go_to("wolf_idle")

	
func run(delta: float) -> void:
	pass
	
