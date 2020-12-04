extends Node

class_name Conversation



var phrases = []
var talk_pos: int = 0



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
	return talk_pos < phrases.size()


