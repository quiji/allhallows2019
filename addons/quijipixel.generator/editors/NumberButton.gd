tool
extends Button

signal number_pressed


var number = -1

func _ready():
	connect("pressed", self, "on_pressed")

func on_pressed():
	emit_signal("number_pressed", number)
	
func set_button(btn_name, n):
	number = n
	text = btn_name

func sub(n):
	number -= n
