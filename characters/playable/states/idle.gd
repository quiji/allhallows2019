extends CharacterAction

var forced_position_met: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.velocity.x = 0.0
	actor.velocity.y = 0.0
	if states.prev_is("fall"):
		actor.sprite_anims.land()
	else:
		actor.sprite_anims.idle()
	forced_position_met = false
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.reached_ground():
		go_to("fall")
		return

	if actor.is_forcing_position:
		
		if actor.get_forcing_position_distance() > 4.0:
			go_to("run")
		elif not actor.forced_position_met:
			actor.forced_position_met = true
			
			if actor.talker_position != null:
				if (actor.talker_position - actor.forced_position).normalized().dot(Vector2(1, 0.0)) >= 0.0:
					actor.facing = actor.FACING_RIGHT
				else:
					actor.facing = actor.FACING_LEFT
					
			actor.emit_signal("forced_position_reached")

		return
		

	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		go_to("run")

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
		#actor.closest_item_box.open(actor)

	if actor.closest_talk_prompt != null and event.is_action_pressed("ui_down"):
		actor.closest_talk_prompt.talk(actor)


	if event.is_action_pressed("jump"):
		go_to("jump")


	if event.is_action_pressed("reload") and actor.can_reload():
		go_to("reload")
