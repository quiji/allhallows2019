extends CharacterAction

const DURATION = 1.0

var timer : float = 0.0
func install() -> void:
	pass

func start(sub_state: String) -> void:

	
	actor.anims.play("flying_mouth")
	timer = DURATION
	
func end(new_state: String) -> void:
	actor.velocity = Vector2()
	
	
	
func run(delta: float) -> void:
	

	if timer <= 0.0:
		go_to("pursue")

	timer -= delta

	var velocity : Vector2 = actor.velocity.linear_interpolate(Vector2(), Smoothstep.stop2( 1.0 - timer / DURATION) )
	actor.move_and_collide(velocity * delta)
		

	

	
