extends Node2D

onready var conversation = $conversation

export (NodePath) var gui_node
export (NodePath) var level_node 


var level = null
var gui

func _ready():
	add_user_signal("action_finished")

	if level_node:
		level = get_node(level_node)
	
	if gui_node:
		gui = get_node(gui_node)
	

	conversation.append_message("werewolf", "This place is off limits!! ")
	conversation.append_message("hunter", "I see, and why is that?")
	conversation.append_message("werewolf", "Who cares, let me grab a bite!")
	conversation.append_message("hunter", "huh?...")
	#conversation.append_message("werewolf", "The subway is falling apart")

func execute() -> bool:
	
	gui.text_bubble.connect("bubble_closed", self, "_on_bubble_closed")
	prompt_conversation()
	return true


func prompt_conversation() -> void:
	if not conversation.is_talk_left():
		gui.text_bubble.disconnect("bubble_closed", self, "_on_bubble_closed")
		emit_signal("action_finished")
		return
	
	var talk = conversation.get_talk()
	var pos = level.get_node(talk.talker).get_talk_position()
	
	gui.prompt_talk(pos, talk.message)
	
	
func _on_bubble_closed() -> void:
	prompt_conversation()


