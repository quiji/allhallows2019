extends Sprite

class_name ParallaxSprite

func _ready():

	position.x += position.x * (get_parent().motion_scale.x - 1.0)
	position.y += position.y * (get_parent().motion_scale.y - 1.0)
