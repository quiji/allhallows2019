extends CharacterAction

var current_point : Vector2
var current_route : int = 0

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.anims.play("flying_eye")

	current_point = actor.route[current_route]
	
	#actor.visibility_area.connect("body_entered", self, "_on_player_detected")
	#####
	actor.visibility_area.queue_free()
	actor.visibility_area = null
	#####
	
func end(new_state: String) -> void:
	#actor.visibility_area.disconnect("body_entered", self, "_on_player_detected")
	#actor.visibility_area.queue_free()
	#actor.visibility_area = null
	pass
	
#func _on_player_detected(player) -> void:
#	actor.target = player
#	go_to("transform")
	
func run(delta: float) -> void:
	var direction : Vector2 = current_point - actor.position
	
	
	var distance : float = actor.arrive(current_point, actor.patrol_slowdown_radius, actor.patrol_speed)
	actor.add_velocities(actor.patrol_speed)
	
	if distance > 20.0:
		actor.move_and_collide(actor.velocity * delta)
	else:
		if current_route + 1 < actor.route.size():
			current_route += 1
		else:
			current_route = 0
		
		current_point = actor.route[current_route]
			

	actor.set_facing(actor.velocity.normalized().dot(Vector2(1, 0)) >= 0.0)
