extends CharacterAction

var walking: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.velocity.x = 0.0
	actor.velocity.y = 0.0
	walking = false
	
	actor.sprite_anims.reload()

	actor.sprite_anims.connect("action_finished", self, "_on_action_finished")
	
func end(new_state: String) -> void:
	actor.sprite_anims.disconnect("action_finished", self, "_on_action_finished")
	actor.gun.reload()
	
func _on_action_finished(anim_name: String) -> void:
	if anim_name == "Reload":
		go_to("idle")
	
func run(delta: float) -> void:


	if not actor.reached_ground(actor.coyote_time):
		go_to("fall")
		return


	if Input.is_action_pressed("ui_left"):
		actor.velocity.x = -actor.walk_speed
		actor.facing = actor.FACING_LEFT
		
		if not walking:
			walking = true
			actor.sprite_anims.swap("ReloadAndWalk")
			
	elif Input.is_action_pressed("ui_right"):
		actor.velocity.x = actor.walk_speed
		actor.facing = actor.FACING_RIGHT

		if not walking:
			walking = true
			actor.sprite_anims.swap("ReloadAndWalk")
			
	elif walking:
		walking = false
		actor.sprite_anims.swap("Reload")


	if walking:
		actor.move_and_slide(actor.velocity, Vector2(0, -1.0))
	
	
	
	
	
func handle_input(event: InputEvent):
	pass