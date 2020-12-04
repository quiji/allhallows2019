extends Node



onready var conversation = $conversation

func _ready():
	add_user_signal("action_finished")
	conversation.append_message("werewolf", "This place is off limits! Only authorized personel alowed.")
	conversation.append_message("hunter", "I see, and why is that?")

func execute() -> bool:
	
	get_parent().level.gui.text_bubble.connect("bubble_closed", self, "_on_bubble_closed")
	prompt_conversation()
	return true


func prompt_conversation() -> void:
	if not conversation.is_talk_left():
		get_parent().level.gui.text_bubble.disconnect("bubble_closed", self, "_on_bubble_closed")
		emit_signal("action_finished")
		return
	
	var talk = conversation.get_talk()
	var pos = get_parent().level.get_node(talk.talker).get_talk_position()
	
	get_parent().level.gui.prompt_talk(pos, talk.message)
	
	
func _on_bubble_closed() -> void:
	prompt_conversation()


