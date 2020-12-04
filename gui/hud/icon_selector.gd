tool
extends Button

signal icon_selected(bullet_type)
signal icon_focused(bullet_type)

enum BulletTypes {Regular=0, Stronger, Obsidian, Silver}
export (bool) var selected = false setget set_selected
export (BulletTypes) var bullet_type = 0 setget set_bullet_type

func _ready():
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")
	connect("pressed", self, "_on_button_pressed")

func set_selected(is_it: bool) -> void:
	selected = is_it
	
	$selection.visible = selected

func set_bullet_type(which: int) -> void:
	
	bullet_type = which
	
	$icons.frame = bullet_type
	
	
func _on_focus_entered():
	$bkg.frame = 1
	emit_signal("icon_focused", $icons.frame)
	

	
func _on_focus_exited():
	$bkg.frame = 0

	
func _on_button_pressed():
	emit_signal("icon_selected", $icons.frame)

	
