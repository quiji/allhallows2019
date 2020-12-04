extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.sprite_anims.box_open()
	
	actor.sprite_anims.connect("action_finished", self, "_on_action_finished")
	actor.closest_item_box.connect("item_collected", self, "_on_item_collected")

func end(new_state: String) -> void:
	actor.sprite_anims.disconnect("action_finished", self, "_on_action_finished")
	actor.closest_item_box.disconnect("item_collected", self, "_on_item_collected")

func _on_action_finished(anim_name: String) -> void:

	if anim_name == "BoxOpen":
		actor.closest_item_box.open(actor)
		#go_to("idle")
		

func _on_item_collected() -> void:
	go_to("idle")


	
func run(delta: float) -> void:
	
	pass

func handle_input(event: InputEvent):
	pass

	
