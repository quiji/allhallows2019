tool
extends Control

signal grabbed_focus(who)

export (int) var bullet_type = 0 setget set_bullet_type
export (bool) var selected = false setget set_selected


func _ready():
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")


func set_bullet_type(new_bullet_type: int) -> void:
	bullet_type = new_bullet_type
	$bullet.frame = new_bullet_type

func blink() -> void:
	$anims.play("reload")

func stop_blink() -> void:
	$anims.play("normal")

	
func set_selected(is_it: bool) -> void:
	selected = is_it
	if selected:
		$base.frame = 1
		$selected.show()
	else:
		$base.frame = 0
		$selected.hide()
	
func _on_focus_entered():
	self.selected = true

	emit_signal("grabbed_focus", self)
	
func _on_focus_exited():
	self.selected = false
	
	
func bounce():
	$anims.play("bounce")

