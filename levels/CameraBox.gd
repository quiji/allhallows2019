extends Area2D


export (bool) var interpolate = false

var limit_left 
var limit_right
var limit_top  
var limit_bottom

var collision_shape_position: Vector2 = Vector2()

func _ready():
	
	
	var i = 0
	var collision_shape = null
	while i < get_child_count() and collision_shape == null:
		var child = get_child(i)
		
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			collision_shape_position = child.position
			collision_shape = child.shape
		
		i += 1
	
	if collision_shape != null:
		limit_left = position.x + collision_shape_position.x - collision_shape.extents.x
		limit_right = position.x + collision_shape_position.x + collision_shape.extents.x
		limit_top = position.y + collision_shape_position.y - collision_shape.extents.y
		limit_bottom = position.y + collision_shape_position.y + collision_shape.extents.y
		
	
