extends CharacterAction

enum AttackState {Run, WaitTilRecover, ExecuteAttack}


#const RECOVERY_DELAY : float = 0.6
#const RECOVERY_DELAY : float = 1.0
const RECOVERY_DELAY : float = 0.1
const FULL_SPEED_ACCEL_TIME : float = 0.4



var timer: float = 0.0

var current_state: int
var target_direction: Vector2
var target_distance: float

var velocity: Vector2
var target_velocity: Vector2
var run_timer: float = 0.0

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("Run")
	
	
	actor.direction = (actor.player_target.position - actor.position).normalized()
	
	
	
	if actor.direction.x >= 0:
		actor.set_facing(true)
		actor.direction = Vector2(1, 0)
	else:
		actor.set_facing(false)
		actor.direction = Vector2(-1, 0)

	target_velocity = actor.direction * actor.run_speed
	run_timer = 0.0


	current_state = AttackState.Run

	
func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:

	target_direction = (actor.player_target.position - actor.position)
	target_distance = target_direction.length()
	target_direction = target_direction.normalized()
	
	velocity = Vector2().linear_interpolate(target_velocity, Smoothstep.stop2(run_timer /FULL_SPEED_ACCEL_TIME))
	if run_timer < FULL_SPEED_ACCEL_TIME:
		run_timer += delta


	actor.move_and_slide(velocity, Vector2(0, -1.0))
	
	
	match current_state:
		AttackState.Run:

			#if actor.direction.dot(target_direction) < 0.8:
			if actor.direction.dot(target_direction) < 0.9:
				current_state = AttackState.WaitTilRecover
				timer = RECOVERY_DELAY
			elif target_distance < 70.0:
				current_state = AttackState.ExecuteAttack
					
		AttackState.WaitTilRecover:
		
			if timer <= 0.0:
				go_to("attack_recovery")
				return
				
			timer -= delta
			
		AttackState.ExecuteAttack:
			go_to("bite")
			return
		
