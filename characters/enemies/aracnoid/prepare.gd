extends CharacterAction

const MIN_JUMP_DISTANCE: float = 170.0

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("Walk")


func end(new_state: String) -> void:
	pass


	
func run(delta: float) -> void:
	var direction: Vector2 = actor.target.position - actor.position
	var length: float = direction.length()
	direction = direction.normalized()

	if length < MIN_JUMP_DISTANCE:
		go_to("start_jump")
	else:
		if direction.x > 0:
			actor.velocity = Vector2(1, 0) * actor.attack_speed
		else:
			actor.velocity = Vector2(-1, 0) * actor.attack_speed
		
		if not actor.can_walk():
			return
			
		actor.move_and_slide(actor.velocity)
		
		actor.set_facing(actor.velocity.normalized().dot(Vector2(1, 0)) >= 0.0)

	
