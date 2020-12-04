extends RigidBody2D

onready var collision: CollisionPolygon2D = $collision
onready var casing: Sprite = $casing
onready var shell_sample = $shell
onready var shell_land_sample = $shell_land

var timer: float = 0.0
var sound_count: int = 2
var grounded: bool = false

func _ready():
	hide()
	set_process(false)
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body) -> void:
	
	if not grounded:
		grounded = true
		if sound_count > 0:
			shell_sample.play()
		elif sound_count >= 0:
			shell_land_sample.play()

		sound_count -= 1


func _on_body_exited(body) -> void:
	
	grounded = false


func throw(pos: Vector2, direction: Vector2, bullet_type: int) -> void:


	position = pos

	match direction:
		Vector2(-1, 0):

			#casing.z_index = -1
			apply_impulse(Vector2(0, 0), Vector2(1, -4).normalized() * rand_range(20.0, 35.0))
			angular_velocity = rand_range(4.0, 8.0)

		Vector2(1, 0):
			apply_impulse(Vector2(0, 0), Vector2(-1, -4).normalized() * rand_range(20.0, 35.0))
			angular_velocity = -rand_range(4.0, 8.0)
			
		Vector2(0, -1):

			#casing.z_index = -1
			apply_impulse(Vector2(0, 0), Vector2(-0.5, -0.1) * rand_range(20.0, 35.0))
			angular_velocity = -rand_range(4.0, 8.0)
			
		Vector2(0, 1):
			apply_impulse(Vector2(0, 0), Vector2(-0.5, 0.1) * rand_range(20.0, 35.0))
			angular_velocity = rand_range(4.0, 8.0)

	casing.frame = bullet_type

	show()
	timer = 1.0
	set_process(true)

func _process(delta):
	
	timer -= delta

	if timer <= 0.0 and linear_velocity.length_squared() < 1.0:

		set_process(false)

		collision.queue_free()
		casing.position = position
		casing.rotation = rotation
		remove_and_skip()
	

