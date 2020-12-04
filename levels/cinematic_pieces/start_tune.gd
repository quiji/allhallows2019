extends Node

export (String) var tune_name


func execute() -> bool:
	
	
	Maestro.call(tune_name)

	return false

