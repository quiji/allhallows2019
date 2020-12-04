extends Node

signal jazz_band_finished


onready var tween: Tween = $Tween
onready var too_dark: AudioStreamPlayer = $too_dark
onready var player: AudioStreamPlayer = $player
onready var bus_idx = AudioServer.get_bus_index("FarClub")

var current_tune: AudioStreamPlayer

func _ready():
	
	too_dark.connect("finished", self, "_on_jazz_band_finished")
	
	tween.connect("tween_completed", self, "_on_tween_completed")

func _on_jazz_band_finished():
	emit_signal("jazz_band_finished")

func _on_tween_completed(object, key):
	object.stop()
	object.volume_db = 0.0

func fade_out():
	tween.interpolate_property(current_tune, "volume_db", 0, -80, 1.0, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	tween.start()


func main_theme():
	player.stream = preload("res://music/jazz_band/Solomon.ogg")
	player.play()
	current_tune = player

func jazz_band(blues: bool = true):
	if blues:
		too_dark.stream = preload("res://music/jazz_band/It's too dark blues.ogg")
	else:
		too_dark.stream = preload("res://music/jazz_band/vamps_dance.ogg")
	too_dark.play()
	current_tune = too_dark

func subway():

	player.stream = preload("res://music/jazz_band/subway.ogg")
	player.play()
	current_tune = player
	
	#$second.stream = preload("res://music/jazz_band/general_wraith_groove.ogg")
	#$second.play()

func general_fight():

	player.stream = preload("res://music/jazz_band/general_fight.ogg")
	player.play()
	current_tune = player

func jazz_next_door():
	AudioServer.set_bus_bypass_effects(bus_idx, false)

	
func jazzing_here():
	AudioServer.set_bus_bypass_effects(bus_idx, true)
