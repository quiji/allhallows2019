extends Button

export (bool) var is_first = false
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	connect("focus_entered", self, "_on_focus_entered")
	connect("pressed", self, "_on_pressed")


func _on_focus_entered():
	
	if not is_first:
		$select.play()
	else:
		is_first = false

func _on_pressed():
	
	$press.play()
