extends "res://levels/Level.gd"


func after_ready():
	$werewolf.connect("wolf_death", self, "_on_wolf_death")
	$werewolf2.connect("wolf_death", self, "_on_wolf_death")
	
	
func _on_wolf_death():
	GameState.set_prop("game_ended", true)
	
	Game.main.load_new_scene("res://gui/screens/start_screen.tscn")
	
	