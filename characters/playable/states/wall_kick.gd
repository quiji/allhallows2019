extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.velocity.y = actor.jump_physics.start(0)

	actor.sprite_anims.start_wall_kick()

	actor.facing *= -1.0
	actor.velocity.x = actor.facing * actor.run_speed
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:

	if actor.sprite_anims.is_start_wall_kick():
		return


	if actor.jump_physics.reached_peak():
		go_to("fall")
		return
	
	actor.velocity.y = actor.jump_physics.process(delta)
	
	"""
	if Input.is_action_pressed("ui_left"):
		actor.velocity.x = -actor.run_speed
		actor.set_facing(actor.FACING_LEFT)
	elif Input.is_action_pressed("ui_right"):
		actor.velocity.x = actor.run_speed
		actor.set_facing(actor.FACING_RIGHT)
	"""
	
	actor.move_and_slide(actor.velocity, Vector2(0, -1.0))
	
	if actor.is_forcing_position:
		return

	
	if Input.is_action_just_pressed("shoot") and actor.gun.can_shoot():

		if Input.is_action_pressed("ui_up"):
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Up, actor.gun.get_ammo() == 0)
		elif Input.is_action_pressed("ui_down"):
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Down, actor.gun.get_ammo() == 0)
		else:
			actor.sprite_anims.shoot(actor.sprite_anims.ShootDirection.Front, actor.gun.get_ammo() == 0)

	
func handle_input(event: InputEvent):
	pass
