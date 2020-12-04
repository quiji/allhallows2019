extends Control

onready var start_game_btn = $vbox/start_game
onready var exit_btn = $vbox/exit
onready var anims = $anims
onready var credits = $credits
onready var title = $title

func _ready():
	Maestro.main_theme()

	start_game_btn.grab_focus()
	
	start_game_btn.connect("pressed", self, "_on_start_pressed")
	exit_btn.connect("pressed", self, "_on_exit_pressed")
	anims.play("intro")

	if GameState.has_prop("game_ended"):
		title.hide()
		credits.show()
	else:
		title.show()
		credits.hide()

func _on_start_pressed():
	anims.play("start_game")

	
func _on_exit_pressed():
	anims.play("quit_game")

	Maestro.fade_out()

func quit_game():
	get_tree().quit()

func start_game():
	Maestro.fade_out()
	Game.main.load_new_scene("res://levels/jazz_club/jazz_club.tscn")

