extends "res://levels/Level.gd"

var jump_sign
var shoot_sign
var wall_jump_sign
var bullets_sign

func after_ready():
	
	$"basement/dr_basem-club".connect("door_entered", self, "_on_entered_basement")
	$"club/dr_club-basement".connect("door_entered", self, "_on_entered_club_by_basement")

	jump_sign = $basement/signs/jump
	shoot_sign = $basement/signs/shoot
	wall_jump_sign = $basement/signs/wall_jump
	bullets_sign = $basement/signs/bullets
	
	
func _on_entered_basement():
	Maestro.jazz_next_door()

	match Game.get_input_type():
		Game.ControllerTypes.Keyboard:
			jump_sign.frame = 0
			shoot_sign.frame = 1
			bullets_sign.frame = 2
		Game.ControllerTypes.Nintendo:
			jump_sign.frame = 3
			shoot_sign.frame = 4
			bullets_sign.frame = 5

		Game.ControllerTypes.Playstation:

			jump_sign.frame = 6
			shoot_sign.frame = 7
			bullets_sign.frame = 8

		Game.ControllerTypes.Xbox:
			jump_sign.frame = 9
			shoot_sign.frame = 10
			bullets_sign.frame = 11
	
	wall_jump_sign.frame = 12



func _on_entered_club_by_basement():
	Maestro.jazzing_here()


