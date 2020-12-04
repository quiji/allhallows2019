extends CharacterAction


var timer: float = 0.0
var direction: Vector2

func install() -> void:
	pass

func start(sub_state: String) -> void:

	
	actor.anims.play("flying_mouth")
	timer = 1.0
	
	
func end(new_state: String) -> void:
	pass
	
	
	
func run(delta: float) -> void:
	
	var enemy_direction: Vector2 = (actor.target.position - actor.position).normalized()
	var target_position : Vector2 = actor.target.position + Vector2(0.0, -1.0) * actor.attack_position_length
	if enemy_direction.x > 0.0:
		target_position += Vector2(-1.0, 0.0) * actor.attack_position_length
	else:
		target_position += Vector2(1.0, 0.0) * actor.attack_position_length
	
	
	
	var distance : float = actor.arrive(target_position, 40.0, actor.pursue_speed)

	actor.add_velocities(actor.pursue_speed)

	actor.velocity += Vector2(0.0, sin(timer * 2.0)) * 40.0 
	
	actor.move_and_collide(actor.velocity * delta)

	actor.set_facing(enemy_direction.dot(Vector2(1, 0)) >= 0.0)

	timer -= delta
	
	if distance <= 20.0 and timer <= 0.0:
		go_to("attack")
