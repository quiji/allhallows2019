extends Control

onready var bullets_back = $bullets_back
onready var bullets_front = $bullets_front

var magazine_size : int = 18 
var magazine_bullet_type: int = 0
var current_bullet: int = 0
var bullets = []

func _ready():
	
	
	pass # Replace with function body.

func set_magazine(new_size: float, bullet_type: int) -> void:
	
	
	magazine_size = new_size
	magazine_bullet_type = bullet_type
	current_bullet = magazine_size - 1
	bullets.clear()
	
	var bullets_col_size: int = bullets_back.get_child_count()
	var bullets_left: int = magazine_size
	

	var i: int = bullets_col_size - 1
	while i >= 0:

		var child = bullets_back.get_child(i)
		if bullets_left > 0:
			bullets.push_back(child)
			child.enabled = true
			child.bullet_type = magazine_bullet_type
			
			bullets_left -= 1
		else:
			child.enabled = false
		
		child = bullets_front.get_child(i)
		if magazine_size <= bullets_col_size or bullets_left == 0:
			child.enabled = false
		else:
			bullets.push_back(child)
			child.enabled = true
			child.bullet_type = magazine_bullet_type
			bullets_left -= 1


		i -= 1

func reload() -> void:
	for i in range(bullets.size()):
		bullets[i].enabled = true

	current_bullet = magazine_size - 1
	
func shoot_bullet()-> void:

	if current_bullet >= 0:
		bullets[current_bullet].enabled = false
		current_bullet -= 1

