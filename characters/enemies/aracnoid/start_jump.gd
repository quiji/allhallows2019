extends CharacterAction

const DIRECTION_END: bool = true
const DIRECTION_START: bool = false



func install() -> void:
	pass

func start(sub_state: String) -> void:


	actor.anims.play("StartJump")
	actor.anims.connect("animation_finished", self, "_on_anim_finished")

	var target: float 
	if actor.current_direction == DIRECTION_END:
		target = actor.end_limit
	else:
		target = actor.start_limit

	var target_position: Vector2 = Vector2(target, actor.position.y)


	var direction: Vector2 = target_position - actor.position
	var length: float = direction.length()
	direction = direction.normalized()
	
	if length > 74:
		length *= 0.5
	#if length > 64:
	#	length *= 0.5
	
	var distance_factor: float = length / 80.0

	
	# ideal distance is 40 + 40
	actor.current_attack_speed = actor.walk_speed * distance_factor
	actor.jump_time = length / actor.current_attack_speed
	if direction.x > 0:
		actor.jump_direction = 1.0
	else:
		actor.jump_direction = -1.0
		
	

	
func end(new_state: String) -> void:
	actor.anims.disconnect("animation_finished", self, "_on_anim_finished")


func _on_anim_finished(anim: String) -> void:
	go_to("jump")

	
func run(delta: float) -> void:
	
	pass

