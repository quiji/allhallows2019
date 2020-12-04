extends Area2D

onready var talk_position = $talk_position
onready var hunter_position = $hunter_position

var talks = []
var current_talk
var player

func _ready():

	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


	for i in range(get_child_count()):
		var child = get_child(i)
		if child.has_method("is_talk_left"):
			talks.push_back(child)
			

func _on_body_entered(player) -> void:
	player.at_talk_prompt(self)
	Game.level.gui.show_cue(self)

func _on_body_exited(player) -> void:
	player.left_talk_prompt()
	Game.level.gui.hide_cue(self)


func talk(who) -> void:
	player = who
	player.force_to_position(hunter_position.global_position, position)
	Game.level.gui.hide_cue(self)

	if current_talk == null or current_talk.can_continue():
	
		if talks.size() > 0:
			current_talk = talks.pop_front()

			while talks.size() > 0 and (current_talk.has_condition() and current_talk.can_continue()):
				current_talk = talks.pop_front()
				
		else:
			current_talk.reset()

	elif current_talk != null:
		current_talk.reset()
	
	Game.level.gui.text_bubble.connect("bubble_closed", self, "_on_bubble_closed")
	player.connect("forced_position_reached", self, "_on_bubble_closed")
	#prompt_conversation()



func prompt_conversation() -> void:
	
	if not current_talk.is_talk_left():
		Game.level.gui.text_bubble.disconnect("bubble_closed", self, "_on_bubble_closed")
		player.disconnect("forced_position_reached", self, "_on_bubble_closed")

		#emit_signal("action_finished")
		player.set_free()
		Game.level.gui.show_cue(self)

		return
	
	var talk = current_talk.get_talk()
	#var pos = talk.talker.get_talk_position()
	var pos = Game.level.get_talker(talk.talker).get_talk_position()
	
	Game.level.gui.prompt_talk(pos, talk.message)

	
func _on_bubble_closed() -> void:
	prompt_conversation()


func get_talk_position() -> Vector2:
	return talk_position.get_global_transform_with_canvas().get_origin()

