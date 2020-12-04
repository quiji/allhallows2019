extends Node2D

export (String) var property_name
export (bool) var new_value


func execute() -> bool:
	
	
	GameState.set_prop(property_name, new_value)

	return false

