extends Node

export (String) var gamestate_condition_variable = ""
export (String) var gamestate_not_condition_variable = ""


func verify_condition() -> bool:
	if gamestate_condition_variable != "":
		return GameState.has_prop(gamestate_condition_variable)
	else:
		return not GameState.has_prop(gamestate_not_condition_variable)
	

func execute() -> bool:
	if verify_condition():
		get_parent().prepend_nodes(get_children())
	else:
		queue_free()

	return false
	





