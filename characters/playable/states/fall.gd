extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	if not states.prev_is("jump"):
		actor.jump_physics.fall()
		actor.sprite_anims.fall()

	
func end(new_state: String) -> void:
	actor.velocity.y = 0.0
	
func run(delta: float) -> void:

	if actor.reached_ground():
		go_to("idle")
		return
	
	actor.velocity.y = actor.jump_physics.process(delta)
	
	if actor.is_forcing_position:
		actor.move_and_slide(actor.velocity, Vector2(0, -1.0))

		return

	
	
	if Input.is_action_pressed("ui_left"):
		actor.velocity.x = -actor.run_speed
		actor.facing = actor.FACING_LEFT
	elif Input.is_action_pressed("ui_right"):
		actor.velocity.x = actor.run_speed
		actor.facing = actor.FACING_RIGHT

	actor.move_and_slide(actor.velocity, Vector2(0, -1.0))
	
	if Input.is_action_just_pressed("shoot") and actor.gun.can_shoot():

		if Input.is_action_pressed("ui_up"):
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Up, actor.gun.get_ammo() == 0)
		elif Input.is_action_pressed("ui_down"):
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Down, actor.gun.get_ammo() == 0)
		else:
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Front, actor.gun.get_ammo() == 0)

	
func handle_input(event: InputEvent):
	
	if actor.is_forcing_position:
		return

	if actor.closest_door != null and event.is_action_pressed("ui_down"):
		actor.closest_door.enter(actor)

	
	if event.is_action_pressed("jump") and actor.can_wall_kick():
		go_to("wall_kick")

