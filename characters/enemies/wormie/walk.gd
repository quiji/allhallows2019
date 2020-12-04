extends CharacterAction

const WALK_TIME: float = 3.0
const IDLE_TIME: float = 2.0
const DIRECTION_END: bool = true
const DIRECTION_START: bool = false

enum SeekState {Idle, Walking}

var current_state: int
var timer: float= 0.0
var wait_for_direction_change: bool = false

var current_direction: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("Walk")
	current_direction = DIRECTION_END
	#actor.anims.connect("animation_finished", self, "_on_animation_finished")
	
	wait_for_direction_change = false

"""
func _on_animation_finished(anim_name: String) -> void:
	wait_for_direction_change  = false
	actor.sprite.flip_h = not actor.sprite.flip_h
	actor.anims.play("Walk")
"""

func end(new_state: String) -> void:
	pass
	#actor.anims.disconnect("animation_finished", self, "_on_animation_finished")
	
func run(delta: float) -> void:

	if wait_for_direction_change:
		return
	
	var target_position: Vector2 
	if current_direction == DIRECTION_END:
		target_position = actor.end_limit
	else:
		target_position = actor.start_limit

	
	var direction: Vector2 = (target_position - actor.position)
	var distance: float = direction.length()
	direction = direction.normalized()
		
	actor.velocity = direction * actor.walk_speed
	actor.move_and_slide(actor.velocity)

	actor.set_facing(actor.velocity.normalized().dot(Vector2(1, 0).rotated(actor.rotation)) >= 0.0)


	if distance < 4.0:
		current_direction = not current_direction
		
		#actor.anims.play("ChangeDirection")
		#wait_for_direction_change = true

