extends Node2D


func _ready():
	
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.has_method("get_talk_position"):
			get_parent().talkers[child.name] = child


