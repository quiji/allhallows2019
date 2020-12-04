extends Node2D

var conversation = null

export (NodePath) var gui_node
export (NodePath) var talk_node


var gui

func _ready():
	add_user_signal("action_finished")

	
	if gui_node:
		gui = get_node(gui_node)
	
	if talk_node:
		conversation = get_node(talk_node)


func execute() -> bool:
	
	gui.text_bubble.connect("bubble_closed", self, "_on_bubble_closed")
	
	return prompt_conversation()


func prompt_conversation() -> bool:
	if not conversation.is_talk_left():
		gui.text_bubble.disconnect("bubble_closed", self, "_on_bubble_closed")
		emit_signal("action_finished")
		return false
	
	var talk = conversation.get_talk()
	#var pos = talk.talker.get_talk_position()
	var pos = Game.level.get_talker(talk.talker).get_talk_position()
	
	gui.prompt_talk(pos, talk.message)
	return true
	
func _on_bubble_closed() -> void:
	prompt_conversation()


