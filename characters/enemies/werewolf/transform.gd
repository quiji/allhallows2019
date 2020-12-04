extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("Transform")
	actor.wolf_transform.play()
	actor.anims.connect("animation_finished", self, "_on_animation_finished")
	
func end(new_state: String) -> void:
	actor.anims.disconnect("animation_finished", self, "_on_animation_finished")
	
func _on_animation_finished(anim_name: String) -> void:

	go_to("wolf_idle")
	
func run(delta: float) -> void:
	pass
	
