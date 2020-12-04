extends Node2D

onready var camera_crew = $camera_crew
onready var gui = $hud


export (NodePath) var player_node 

var player = null

var talkers = {}

func _ready():
	
	Game.level = self
	
	if player_node:
		player = get_node(player_node)

		player.update_game_state()
		
		camera_crew.actor = player
		

		get_tree().call_group("player_hunters", "set_player_target", player)
		

	for i in range(get_child_count()):
		var child = get_child(i)
		if child.has_method("get_talk_position"):
			talkers[child.name] = child
		
	get_tree().call_group("parallax_sprites", "reposition")
	after_ready()
	gui.open_screen()

func after_ready():
	pass
	
	
	
func get_talker(who: String):
	return talkers[who]

	
	