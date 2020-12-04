extends CharacterAction

const DIRECTION_END: bool = true
const DIRECTION_START: bool = false


func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.anims.play("Land")


	var target: float 
	if actor.current_direction == DIRECTION_END:
		target = actor.end_limit
	else:
		target = actor.start_limit

	var target_position: Vector2 = Vector2(target, actor.position.y)

	var direction: Vector2 = target_position - actor.position
	var length: float = direction.length()
	
	if length < 10.0:
		actor.current_direction = not actor.current_direction
		
	actor.anims.connect("animation_finished", self, "_on_anim_finished")

func end(new_state: String) -> void:

	actor.anims.disconnect("animation_finished", self, "_on_anim_finished")


func _on_anim_finished(anim: String) -> void:
	go_to("start_jump")
	
func run(delta: float) -> void:
	pass
