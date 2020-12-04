extends Node

export (String, MULTILINE) var text = '[{"hunter": "yes" }]'
export (String) var gamestate_condition_variable = ""
export (String) var gamestate_variable_setter = ""



var phrases = []
var talk_pos: int = 0

func _ready():

	var result = JSON.parse(text)
	
	for i in range(result.result.size()):
		var keys = result.result[i].keys()
		append_message(keys[0], result.result[i][keys[0]])

func reset():
	talk_pos = 0

func can_continue() -> bool:
	if gamestate_condition_variable != "":
		return GameState.has_prop(gamestate_condition_variable)
	else:
		return true

func has_condition() -> bool:
	return gamestate_condition_variable != ""

func append_message(tlkr: String, msg: String) -> void:
	
	var text = {
		talker = tlkr,
		message = msg
	}
	
	phrases.push_back(text)
	

func get_talk() -> Dictionary:
	if talk_pos < phrases.size():
		talk_pos += 1

		return phrases[talk_pos - 1]
		
		
	return {}
	
func is_talk_left() -> bool:
	var result: bool = talk_pos < phrases.size()
	
	if not result and gamestate_variable_setter != "":
		GameState.set_prop(gamestate_variable_setter, true)
	
	return result


