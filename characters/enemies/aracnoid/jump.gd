extends CharacterAction

var jump_speed : float = 0.0
var jump_gravity : float = 0.0
var timer: float = 0.0
var jump_to_peak: float = 0.0

func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.anims.play("Jump")
	
	jump_to_peak = actor.jump_time / 2.0
	
	jump_speed = 2 * actor.jump_height / jump_to_peak
	jump_gravity = -2 * actor.jump_height / (jump_to_peak * jump_to_peak)

	timer = 0.0
	actor.anims.connect("animation_finished", self, "_on_anim_finished")


func end(new_state: String) -> void:

	actor.anims.disconnect("animation_finished", self, "_on_anim_finished")

func _on_anim_finished(anim: String) -> void:
	actor.anims.play("JumpPeak")

	
func run(delta: float) -> void:

	actor.velocity = Vector2(actor.jump_direction * actor.current_attack_speed, -jump_speed)

	actor.move_and_slide(actor.velocity)
	
	actor.set_facing(actor.velocity.normalized().dot(Vector2(1, 0)) >= 0.0)

	jump_speed += jump_gravity * delta

	timer += delta
	
	
	if jump_speed <= 0.0:
		go_to("fall")

