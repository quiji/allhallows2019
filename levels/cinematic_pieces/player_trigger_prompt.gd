extends Area2D

onready var collision_mask_backup: int = collision_mask
var enabled: bool = false setget set_enabled

func _ready():
	
	add_user_signal("action_finished")
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func set_enabled(is_it: bool) -> void:
	enabled = is_it
	
	if not enabled:
		collision_mask = 0
	else:
		collision_mask = collision_mask_backup


func _on_body_entered(player) -> void:
	player.at_talk_prompt(self)


func _on_body_exited(player) -> void:
	player.left_talk_prompt()


func talk(who) -> void:
	emit_signal("action_finished")
	
	

