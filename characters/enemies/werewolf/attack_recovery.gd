extends CharacterAction


const RECOVERY_DURATION: float = 0.7


var timer: float = 0.0
var start_velocity : Vector2
var end_velocity : Vector2

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("AttackRecovery")
	

	timer = 0.0

	start_velocity = actor.direction * actor.run_speed
	end_velocity = Vector2()
	
func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	if timer > RECOVERY_DURATION:
		if actor.should_we_roar():
			go_to("roar")
		else:
			go_to("attack")
		return

	var velocity : Vector2 = start_velocity.linear_interpolate(end_velocity, Smoothstep.start3(timer / RECOVERY_DURATION))
	actor.move_and_slide(velocity, Vector2(0, -1.0))
	
	timer += delta
	
	

