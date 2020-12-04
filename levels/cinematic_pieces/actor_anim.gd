extends Node2D


export (NodePath) var actor_path
export (String) var method_name

var actor

func _ready():
	add_user_signal("action_finished")

	if actor_path:
		actor = get_node(actor_path)

	set_process(false)

func execute() -> bool:
	
	
	actor.call(method_name)
	set_process(true)

	return true


func _process(delta):
	
	emit_signal("action_finished")
