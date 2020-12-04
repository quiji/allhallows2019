extends CharacterAction


const ATTACK_TIME = 2.0

var timer: float
var direction : Vector2
var distance : float

var gravity : float
var start_position : Vector2
var end_position : Vector2

	
func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("attack")

	timer = 0.0

	actor.attacking = true

	var enemy_direction: Vector2 = (actor.target.position - actor.position).normalized()
	start_position = actor.target.position + Vector2(0.0, -1.0) * actor.attack_position_length
	
	if enemy_direction.x > 0.0:
		end_position = start_position + Vector2(1.0, 0.0) * actor.attack_position_length
		start_position += Vector2(-1.0, 0.0) * actor.attack_position_length
	else:
		end_position = start_position + Vector2(-1.0, 0.0) * actor.attack_position_length
		start_position += Vector2(1.0, 0.0) * actor.attack_position_length

	direction = (end_position - start_position)
	distance = direction.length()
	direction = direction.normalized()

	actor.velocity.x = direction.x * distance / ATTACK_TIME
	
	var height: float = actor.attack_position_length * 0.9
	var half_time: float = ATTACK_TIME / 2.0
	actor.velocity.y = 2.0 * height / half_time
	gravity = -2.0 * height / (half_time * half_time)

	
func end(new_state: String) -> void:
	actor.attacking = false

	
	
	
func run(delta: float) -> void:
	

	timer += delta
	

	actor.move_and_collide(actor.velocity * delta)
	
	actor.velocity.y += gravity * delta
	
	
	if timer > ATTACK_TIME * 0.9:
		go_to("prepare")
	