extends "res://levels/cinematic_pieces/Condition.gd"


func verify_condition() -> bool:

	return not GameState.get_prop("subway_werewolf_intro_played")




