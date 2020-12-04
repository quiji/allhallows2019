extends CharacterAction

func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.velocity.x = 0.0
	actor.velocity.y = 0.0
	

	actor.sprite_anims.connect("action_finished", self, "_on_action_finished")
	actor.sprite_anims.hit()
	
func end(new_state: String) -> void:
	actor.sprite_anims.disconnect("action_finished", self, "_on_action_finished")

	
func _on_action_finished(anim_name: String) -> void:
	if anim_name == "Hit":
		if not actor.reached_ground():
			go_to("fall")
		else:
			go_to("idle")
	
func run(delta: float) -> void:
	pass
	
	
func handle_input(event: InputEvent):
	pass