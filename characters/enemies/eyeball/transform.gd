extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("spotted")
	actor.anims.connect("animation_finished", self, "_on_animation_finished")
	
func _on_animation_finished(anim_name: String) -> void:
	go_to("pursue")
	
func end(new_state: String) -> void:
	actor.anims.disconnect("animation_finished", self, "_on_animation_finished")
	
	
func run(delta: float) -> void:
	pass