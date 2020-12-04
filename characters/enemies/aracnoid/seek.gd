extends CharacterAction

const IDLE_TIME: float = 1.0
const DIRECTION_END: bool = true
const DIRECTION_START: bool = false

enum SeekState {Idle, Walking}

var current_state: int
var timer: float= 0.0



func install() -> void:
	pass

func start(sub_state: String) -> void:

	current_state = SeekState.Idle
	actor.anims.play("Idle")
	
	timer = IDLE_TIME

	actor.current_direction = DIRECTION_START
	
	actor.connect("aracnoid_hurt", self, "_on_aracnoide_hurt")
	
func end(new_state: String) -> void:
	actor.disconnect("aracnoid_hurt", self, "_on_aracnoide_hurt")
	
func _on_aracnoide_hurt() -> void:
	go_to("start_jump")

	
func run(delta: float) -> void:
	
	
	match current_state:
		SeekState.Idle:
			
			if timer >= 0:
				timer -= delta
			else:
				current_state = SeekState.Walking
				
				actor.current_direction = not actor.current_direction
				
				actor.anims.play("Walk")

			
		SeekState.Walking:
			
			var target: float 
			if actor.current_direction == DIRECTION_END:
				target = actor.end_limit
			else:
				target = actor.start_limit

			var target_position: Vector2 = Vector2(target, actor.position.y)
			
			var direction: Vector2 = (target_position - actor.position)
			var distance: float = direction.length()
			direction = direction.normalized()
			
			if direction.x <= 0.0:
				direction = Vector2(-1, 0) 
			else:
				direction = Vector2(1, 0) 
			
			actor.velocity = direction * actor.walk_speed
			actor.move_and_slide(actor.velocity)
			
			actor.set_facing(actor.velocity.normalized().dot(Vector2(1, 0)) >= 0.0)


			if distance < 4.0:
				current_state = SeekState.Idle
				timer = IDLE_TIME
				actor.anims.play("Idle")

	
