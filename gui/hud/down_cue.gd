extends Control

var current_actor = null


func _ready():
	hide()
	set_physics_process(false)

func prompt(actor):
	current_actor = actor
	set_physics_process(true)
	show()
	

func stop():
	set_physics_process(false)
	hide()

func _physics_process(delta):
	
	var target_pos: Vector2 = Vector2(0.0, 0.0)
	if current_actor.has_method("get_talk_position"):
		target_pos = current_actor.get_talk_position()
	elif current_actor.has_method("get_cue_position"):
		target_pos = current_actor.get_cue_position()
		
	rect_position = target_pos

	
