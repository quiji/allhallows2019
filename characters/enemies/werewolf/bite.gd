extends CharacterAction


#const RECOVERY_DURATION: float = 0.6
#const RECOVERY_DURATION: float = 0.8
const RECOVERY_DURATION: float = 1.0
const BITTEN_RECOVERY_DURATION: float = 1.6


var timer: float = 0.0
var start_velocity : Vector2
var end_velocity : Vector2
var bitten: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("Attack")
	
	actor.bite_sfx.play()

	timer = 0.0

	start_velocity = actor.direction * actor.run_speed
	end_velocity = start_velocity * 0.05
	bitten = false
	
func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	if (not bitten and timer > RECOVERY_DURATION) or timer > BITTEN_RECOVERY_DURATION:
		
		#BITTEN
		
		if actor.should_we_roar():
			go_to("roar")
		else:
			go_to("attack")

		return


	var velocity : Vector2 = start_velocity.linear_interpolate(end_velocity, Smoothstep.stop6(timer / RECOVERY_DURATION))
	actor.move_and_slide(velocity, Vector2(0, -1.0))
	
	timer += delta
	
	
	if timer > 0.29 and timer < 0.31:
		if actor.is_player_bitable:
			actor.player_target.hit(actor.bite_damage)
			bitten = true
		Game.level.camera_crew.werewolf_bit_shake(actor.is_player_bitable)
		
	
