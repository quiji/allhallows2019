
extends Control

signal bubble_closed

onready var text = $bkg/margins/text
onready var bkg = $bkg
onready var anims = $anims


func _ready():
	hide()
	set_process_unhandled_input(false)
	
	anims.connect("animation_finished", self, "_on_animation_finished")


func show_message(pos: Vector2, msg: String) -> void:
	rect_position = pos
	bkg.rect_position.x = -bkg.rect_size.x * 0.5
	bkg.rect_position.y = -bkg.rect_size.y
	text.bbcode_text = msg
	
	show()
	set_process_unhandled_input(true)
	anims.play("show")
	
func _on_animation_finished(anim_name: String) -> void:
	
	if anim_name == "hide":
		hide()
		set_process_unhandled_input(false)
		emit_signal("bubble_closed")

	
func _unhandled_input(event):
	
	if event.is_action_pressed("jump") or event.is_action_pressed("shoot") or event.is_action_pressed("reload") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		anims.play("hide")
		
