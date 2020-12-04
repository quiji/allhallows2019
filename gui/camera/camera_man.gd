
extends Camera2D

class_name CameraMan, "res://gui/camera/icon.png"


onready var shake = preload("./screenshake.gd").new(self)

func _physics_process(delta):
	
	shake.process(delta)


