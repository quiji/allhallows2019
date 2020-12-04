extends Node2D

export (NodePath) var player_node 
export (NodePath) var camera_crew_node 

var player = null
var camera_crew = null

func _ready():
	add_user_signal("action_finished")

	if player_node:
		player = get_node(player_node)

	if camera_crew_node:
		camera_crew = get_node(camera_crew_node)

func execute() -> bool:
	
	player.force_to_position(get_child(0).position)
	
	camera_crew.connect("film_point_finished", self, "_on_film_point_finished")
	camera_crew.film_point(get_child(1).position)
	return true

func _on_film_point_finished() -> void:
	camera_crew.disconnect("film_point_finished", self, "_on_film_point_finished")
	
	emit_signal("action_finished")

