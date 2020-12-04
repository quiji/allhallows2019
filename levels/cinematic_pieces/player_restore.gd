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
	
	
	camera_crew.connect("actore_restore_finished", self, "_on_actore_restore_finished")
	camera_crew.actore_restore()
	return true

func _on_actore_restore_finished() -> void:
	
	camera_crew.disconnect("actore_restore_finished", self, "_on_actore_restore_finished")
	player.set_free()
	
	emit_signal("action_finished")

