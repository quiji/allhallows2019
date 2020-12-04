extends CharacterAction

const WAIT_TIME :float = 0.3
const PLAYER_SENSE_DISTANCE : float = 400.0

var target_sighted: bool = false
var timer: float = 0.0


func install() -> void:
	pass


func start(sub_state: String) -> void:

	actor.anims.play("Idle")
	

	timer = WAIT_TIME

	
func end(new_state: String) -> void:
	pass
	


	
func run(delta: float) -> void:
	
	timer -= delta
	
	if timer > 0.0:
		return

	
	var distance: float
	actor.direction = (actor.player_target.position - actor.position)
	distance = actor.direction.length()
	actor.direction = actor.direction.normalized()

	if not target_sighted:
		if distance < PLAYER_SENSE_DISTANCE:
			go_to("roar")
			target_sighted = true
		return

	go_to("attack")
	