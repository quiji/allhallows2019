extends Node2D

export (NodePath) var actor_path
 
var actor

func _ready():
	if actor_path:
		actor = get_node(actor_path)

func execute() -> bool:
	
	actor.enabled = true
	#emit_signal("action_finished")
	return false

