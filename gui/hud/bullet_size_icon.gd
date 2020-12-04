tool
extends Control

enum IconType {BulletCount, MagazineCount, MagazineSize}

export (IconType) var icon_type setget set_icon_type
export (int) var value = 0 setget set_value
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_icon_type(new_type: int) -> void:
	icon_type = new_type
	
	$icon/icon.frame = icon_type

func set_value(new_value: int) -> void:
	if new_value == -1:
		value = new_value
		$number.text = "--"
	else:
		value = new_value
		$number.text = str(value)

