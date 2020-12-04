extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.sprite_anims.run()

	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.reached_ground(actor.coyote_time):
		go_to("fall")
		return
		
	if actor.is_forcing_position:
		if actor.get_forcing_position_distance() <= 4.0:
			go_to("idle")
			actor.forced_position_met = true
			if actor.talker_position != null:
				if (actor.talker_position - actor.forced_position).normalized().dot(Vector2(1, 0.0)) >= 0.0:
					actor.facing = actor.FACING_RIGHT
				else:
					actor.facing = actor.FACING_LEFT
					
			actor.emit_signal("forced_position_reached")

			return
		
		if actor.forced_position_direction.dot(Vector2(1, 0.0)) >= 0.0:
			actor.velocity.x = actor.run_speed
			actor.facing = actor.FACING_RIGHT
		else:
			actor.velocity.x = -actor.run_speed
			actor.facing = actor.FACING_LEFT
		
		actor.move_and_slide(actor.velocity, Vector2(0, -1.0))
		return

		
	if Input.is_action_pressed("ui_left"):
		actor.velocity.x = -actor.run_speed
		actor.facing = actor.FACING_LEFT
	elif Input.is_action_pressed("ui_right"):
		actor.velocity.x = actor.run_speed
		actor.facing = actor.FACING_RIGHT
	else:
		go_to("idle")

	actor.move_and_slide(actor.velocity, Vector2(0, -1.0))
	
	if Input.is_action_just_pressed("shoot") and actor.gun.can_shoot():

		if Input.is_action_pressed("ui_up"):
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Up, actor.gun.get_ammo() == 0)
		else:
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Front, actor.gun.get_ammo() == 0)
		
	
func handle_input(event: InputEvent):
	
	if actor.is_forcing_position:
		return

	if actor.closest_door != null and event.is_action_pressed("ui_down"):
		actor.closest_door.enter(actor)

	if actor.closest_item_box != null and event.is_action_pressed("ui_down"):
		go_to("open_item_box")

	if actor.closest_talk_prompt != null and event.is_action_pressed("ui_down"):
		actor.closest_talk_prompt.talk(actor)

	
	if event.is_action_pressed("jump"):
		go_to("jump")

	if event.is_action_pressed("reload") and actor.can_reload():
		go_to("reload")

